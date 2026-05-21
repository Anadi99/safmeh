import 'dart:typed_data';

class AudioSegment {
  final String sessionId;
  final int segmentIndex;
  final Uint8List encryptedData;
  final DateTime capturedAt;
  final String localPath;

  const AudioSegment({
    required this.sessionId,
    required this.segmentIndex,
    required this.encryptedData,
    required this.capturedAt,
    required this.localPath,
  });
}

enum AudioUploadStatus { pending, uploading, uploaded, failed }

class AudioSegmentUploadTask {
  final AudioSegment segment;
  AudioUploadStatus status;
  int retryCount;
  String? uploadedUrl;

  AudioSegmentUploadTask({
    required this.segment,
    this.status = AudioUploadStatus.pending,
    this.retryCount = 0,
    this.uploadedUrl,
  });
}

/// Abstract interface for audio evidence recording and upload.
abstract class AudioEvidenceService {
  /// Start recording for the given SOS session.
  Future<void> startRecording(String sessionId);

  /// Stop recording and flush the final segment.
  Future<void> stopRecording();

  /// Stream of encrypted audio segments emitted every 30 seconds.
  Stream<AudioSegment> get segmentStream;

  /// Whether recording is currently active.
  bool get isRecording;

  /// Retry any failed uploads (call when connectivity is restored).
  Future<void> retryFailedUploads();

  /// All pending/failed upload tasks.
  List<AudioSegmentUploadTask> get pendingUploads;
}
