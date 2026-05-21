import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/services/audio_evidence_service.dart';
import 'package:safmeh/services/mock_audio_evidence_service.dart';

void main() {
  group('MockAudioEvidenceService', () {
    late MockAudioEvidenceService service;

    setUp(() => service = MockAudioEvidenceService());
    tearDown(() => service.dispose());

    test('isRecording is false initially', () {
      expect(service.isRecording, isFalse);
    });

    test('startRecording sets isRecording to true', () async {
      await service.startRecording('session-001');
      expect(service.isRecording, isTrue);
      await service.stopRecording();
    });

    test('stopRecording sets isRecording to false', () async {
      await service.startRecording('session-001');
      await service.stopRecording();
      expect(service.isRecording, isFalse);
    });

    test('stopRecording emits a final segment', () async {
      final segments = <AudioSegment>[];
      final sub = service.segmentStream.listen(segments.add);

      await service.startRecording('session-001');
      await service.stopRecording();

      await Future.delayed(const Duration(milliseconds: 50));
      await sub.cancel();

      expect(segments.length, 1); // final segment on stop
    });

    test('emitted segment has correct sessionId', () async {
      final completer = Completer<AudioSegment>();
      final sub = service.segmentStream.listen(completer.complete);

      await service.startRecording('session-abc');
      await service.stopRecording();

      final segment =
          await completer.future.timeout(const Duration(seconds: 2));
      await sub.cancel();

      expect(segment.sessionId, 'session-abc');
    });

    test('segment has non-empty encrypted data', () async {
      final completer = Completer<AudioSegment>();
      final sub = service.segmentStream.listen(completer.complete);

      await service.startRecording('session-001');
      await service.stopRecording();

      final segment =
          await completer.future.timeout(const Duration(seconds: 2));
      await sub.cancel();

      expect(segment.encryptedData.isNotEmpty, isTrue);
    });

    test('pendingUploads grows after segment emission', () async {
      await service.startRecording('session-001');
      await service.stopRecording();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(service.pendingUploads.length, greaterThan(0));
    });

    test('retryFailedUploads marks failed tasks as uploaded', () async {
      await service.startRecording('session-001');
      await service.stopRecording();
      await Future.delayed(const Duration(milliseconds: 50));

      // Manually mark as failed
      for (final task in service.pendingUploads) {
        task.status = AudioUploadStatus.failed;
      }

      await service.retryFailedUploads();

      expect(
        service.pendingUploads
            .every((t) => t.status == AudioUploadStatus.uploaded),
        isTrue,
      );
    });
  });
}
