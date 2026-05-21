import 'dart:async';
import '../cubits/sos/sos_cubit.dart';
import '../cubits/sos/sos_state.dart';
import '../models/sos_event.dart';
import '../models/trusted_contact.dart';
import 'audio_evidence_service.dart';
import 'hardware_button_channel.dart';
import 'notification_service.dart';

/// Coordinates the full SOS flow:
/// Gesture detection → SosCubit → AudioEvidenceService → NotificationService
///
/// Wire this up in main.dart or a top-level widget after login.
class SosCoordinator {
  final SosCubit _sosCubit;
  final AudioEvidenceService _audioService;
  final NotificationService _notificationService;
  final HardwareButtonChannel _hardwareChannel;
  final List<TrustedContact> Function() _getContacts;

  StreamSubscription<SosState>? _sosSub;
  StreamSubscription<SosTriggerEvent>? _gestureSub;

  SosCoordinator({
    required SosCubit sosCubit,
    required AudioEvidenceService audioService,
    required NotificationService notificationService,
    required HardwareButtonChannel hardwareChannel,
    required List<TrustedContact> Function() getContacts,
  })  : _sosCubit = sosCubit,
        _audioService = audioService,
        _notificationService = notificationService,
        _hardwareChannel = hardwareChannel,
        _getContacts = getContacts;

  /// Start listening for SOS gestures and state changes.
  void start() {
    // Listen for hardware button gestures
    _hardwareChannel.startListening();
    _gestureSub = _hardwareChannel.sosTriggerStream.listen(_onGestureTrigger);

    // Listen for SOS state changes to start/stop audio and send notifications
    _sosSub = _sosCubit.stream.listen(_onSosStateChange);
  }

  /// Stop all listeners.
  void stop() {
    _hardwareChannel.stopListening();
    _gestureSub?.cancel();
    _sosSub?.cancel();
  }

  void _onGestureTrigger(SosTriggerEvent event) {
    if (!_sosCubit.isActive) {
      _sosCubit.activate(event.trigger as SosTrigger);
    }
  }

  void _onSosStateChange(SosState state) async {
    if (state is SosActive) {
      // Start audio recording silently
      await _audioService.startRecording(state.event.id);

      // Send emergency alerts to all trusted contacts
      final contacts = _getContacts();
      if (contacts.isNotEmpty) {
        final alert = EmergencyAlert(
          userId: state.event.userId,
          location: state.event.locationAtActivation,
          timestamp: state.event.activatedAt,
          message: 'Emergency alert from SafMeh',
        );
        await _notificationService.sendEmergencyAlert(alert, contacts);
      }
    } else if (state is SosDeactivating || state is SosResolved) {
      // Stop audio recording
      await _audioService.stopRecording();
    }
  }

  void dispose() {
    stop();
    _hardwareChannel.dispose();
  }
}
