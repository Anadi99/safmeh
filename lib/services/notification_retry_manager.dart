import 'dart:async';
import 'notification_service.dart';
import '../models/trusted_contact.dart';

class PendingNotification {
  final EmergencyAlert alert;
  final List<TrustedContact> contacts;
  final NotificationService service;
  int attemptCount;
  NotificationStatus status;

  PendingNotification({
    required this.alert,
    required this.contacts,
    required this.service,
    this.attemptCount = 0,
    this.status = NotificationStatus.pending,
  });
}

/// Manages retry logic for failed notification deliveries.
/// Retries up to 3 times at 10-second intervals.
class NotificationRetryManager {
  static const int maxAttempts = 3;
  static const int retryIntervalSeconds = 10;

  final List<PendingNotification> _queue = [];
  Timer? _retryTimer;

  List<PendingNotification> get queue => List.unmodifiable(_queue);

  /// Add an alert to the retry queue and attempt delivery immediately.
  Future<void> sendWithRetry(
    EmergencyAlert alert,
    List<TrustedContact> contacts,
    NotificationService service,
  ) async {
    final pending = PendingNotification(
      alert: alert,
      contacts: contacts,
      service: service,
    );
    _queue.add(pending);
    await _attempt(pending);
  }

  Future<void> _attempt(PendingNotification pending) async {
    if (pending.attemptCount >= maxAttempts) {
      pending.status = NotificationStatus.failed;
      return;
    }

    pending.attemptCount++;
    try {
      final results = await pending.service.sendEmergencyAlert(
        pending.alert,
        pending.contacts,
      );
      final allSent = results.every((r) => r.status == NotificationStatus.sent);
      if (allSent) {
        pending.status = NotificationStatus.sent;
      } else if (pending.attemptCount < maxAttempts) {
        // Schedule retry
        _scheduleRetry(pending);
      } else {
        pending.status = NotificationStatus.failed;
      }
    } catch (_) {
      if (pending.attemptCount < maxAttempts) {
        _scheduleRetry(pending);
      } else {
        pending.status = NotificationStatus.failed;
      }
    }
  }

  void _scheduleRetry(PendingNotification pending) {
    Timer(Duration(seconds: retryIntervalSeconds), () => _attempt(pending));
  }

  void dispose() {
    _retryTimer?.cancel();
  }
}
