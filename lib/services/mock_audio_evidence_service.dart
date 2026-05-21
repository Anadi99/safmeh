import 'dart:async';
import 'dart:typed_data';
import 'audio_evidence_service.dart';

/// Mock audio evidence service for development/testing.
/// Simulates recording by emitting fake encrypted segments every 30 seconds.
class MockAudioEvidenceService implements AudioEvidenceService {
  final _controller = StreamController<AudioSegment>.broadcast();
  Timer? _segmentTimer;
  bool _isRecording = false;
  String? _sessionId;
  int _segmentIndex = 0;
  final List<AudioSegmentUploadTask> _pendingUploads = [];

  static const int segmentIntervalSeconds = 30;

  @override
  Stream<AudioSegment> get segmentStream => _controller.stream;

  @override
  bool get isRecording => _isRecording;

  @override
  List<AudioSegmentUploadTask> get pendingUploads =>
      List.unmodifiable(_pendingUploads);

  @override
  Future<void> startRecording(String sessionId) async {
    if (_isRecording) return;
    _isRecording = true;
    _sessionId = sessionId;
    _segmentIndex = 0;

    // Emit a segment every 30 seconds
    _segmentTimer = Timer.periodic(
      const Duration(seconds: segmentIntervalSeconds),
      (_) => _emitSegment(),
    );
  }

  @override
  Future<void> stopRecording() async {
    if (!_isRecording) return;
    _segmentTimer?.cancel();
    _segmentTimer = null;
    _isRecording = false;

    // Emit final segment
    if (_sessionId != null) {
      _emitSegment();
    }
    _sessionId = null;
    _segmentIndex = 0;
  }

  @override
  Future<void> retryFailedUploads() async {
    final failed = _pendingUploads
        .where((t) => t.status == AudioUploadStatus.failed && t.retryCount < 3)
        .toList();
    for (final task in failed) {
      task.retryCount++;
      task.status = AudioUploadStatus.uploading;
      // Simulate upload success in mock
      await Future.delayed(const Duration(milliseconds: 100));
      task.status = AudioUploadStatus.uploaded;
      task.uploadedUrl =
          'mock://uploaded/${task.segment.sessionId}/${task.segment.segmentIndex}';
    }
  }

  void _emitSegment() {
    final session = _sessionId;
    if (session == null) return;

    // Simulate AES-256 encrypted audio data (fake bytes in mock)
    final fakeEncrypted = Uint8List.fromList(
      List.generate(1024, (i) => (i + _segmentIndex) % 256),
    );

    final segment = AudioSegment(
      sessionId: session,
      segmentIndex: _segmentIndex++,
      encryptedData: fakeEncrypted,
      capturedAt: DateTime.now(),
      localPath: '/mock/audio/$session/segment_$_segmentIndex.enc',
    );

    final task = AudioSegmentUploadTask(segment: segment);
    _pendingUploads.add(task);
    _controller.add(segment);
  }

  void dispose() {
    _segmentTimer?.cancel();
    _controller.close();
  }
}
