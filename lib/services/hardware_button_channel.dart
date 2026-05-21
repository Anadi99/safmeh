import 'dart:async';
import 'package:flutter/services.dart';
import 'sos_gesture_detector.dart';

/// Dart-side platform channel for hardware button events.
/// The native side (Android/iOS) sends events through this channel.
class HardwareButtonChannel {
  static const EventChannel _eventChannel =
      EventChannel('com.safmeh/hardware_button_events');

  final SosGestureDetector _gestureDetector;
  StreamSubscription<dynamic>? _subscription;

  final _sosController = StreamController<SosTriggerEvent>.broadcast();

  HardwareButtonChannel({SosGestureDetector? gestureDetector})
      : _gestureDetector = gestureDetector ?? SosGestureDetector();

  /// Stream of SOS triggers detected from hardware buttons.
  Stream<SosTriggerEvent> get sosTriggerStream => _sosController.stream;

  /// Start listening to hardware button events from the platform.
  void startListening() {
    _subscription = _eventChannel.receiveBroadcastStream().listen(
      _onEvent,
      onError: (_) {}, // Silently ignore platform errors in mock/test
    );
  }

  /// Stop listening to hardware button events.
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _onEvent(dynamic event) {
    if (event is! Map) return;
    final type = event['type'] as String?;
    final timestampMs = event['timestamp'] as int?;
    if (type == null || timestampMs == null) return;

    final timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs);

    switch (type) {
      case 'power_button':
        final trigger = _gestureDetector.onPowerButtonPress(timestamp);
        if (trigger != null) {
          _sosController.add(SosTriggerEvent(trigger: trigger, timestamp: timestamp));
        }
      case 'volume_up':
        final trigger = _gestureDetector.onVolumeButtonPress(
          VolumeButtonEvent.up,
          timestamp,
        );
        if (trigger != null) {
          _sosController.add(SosTriggerEvent(trigger: trigger, timestamp: timestamp));
        }
      case 'volume_down':
        final trigger = _gestureDetector.onVolumeButtonPress(
          VolumeButtonEvent.down,
          timestamp,
        );
        if (trigger != null) {
          _sosController.add(SosTriggerEvent(trigger: trigger, timestamp: timestamp));
        }
    }
  }

  /// Simulate a hardware button event (for testing without real platform).
  void simulateEvent(dynamic event) => _onEvent(event);

  void dispose() {
    stopListening();
    _sosController.close();
  }
}

class SosTriggerEvent {
  final dynamic trigger; // SosTrigger
  final DateTime timestamp;

  const SosTriggerEvent({required this.trigger, required this.timestamp});
}
