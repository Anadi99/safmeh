import 'notification_service.dart';
import '../models/trusted_contact.dart';
import '../models/location_data.dart';

/// Mock notification service — simulates delivery without real FCM/Twilio.
class MockNotificationService implements NotificationService {
  final List<EmergencyAlert> sentAlerts = [];
  final List<RouteUpdate> sentRouteUpdates = [];
  bool shouldFail = false; // Set to true to simulate failures

  @override
  Future<List<NotificationResult>> sendEmergencyAlert(
    EmergencyAlert alert,
    List<TrustedContact> contacts,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (shouldFail) {
      return contacts
          .map((c) => NotificationResult(
                contact: c,
                channel: NotificationChannel.push,
                status: NotificationStatus.failed,
                errorMessage: 'Simulated failure',
              ))
          .toList();
    }

    sentAlerts.add(alert);
    return contacts
        .expand((c) => [
              NotificationResult(
                contact: c,
                channel: NotificationChannel.push,
                status: NotificationStatus.sent,
              ),
              if (c.email != null)
                NotificationResult(
                  contact: c,
                  channel: NotificationChannel.email,
                  status: NotificationStatus.sent,
                ),
              NotificationResult(
                contact: c,
                channel: NotificationChannel.sms,
                status: NotificationStatus.sent,
              ),
            ])
        .toList();
  }

  @override
  Future<List<NotificationResult>> sendRouteUpdate(
    RouteUpdate update,
    List<TrustedContact> contacts,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    sentRouteUpdates.add(update);
    return contacts
        .map((c) => NotificationResult(
              contact: c,
              channel: NotificationChannel.push,
              status: NotificationStatus.sent,
            ))
        .toList();
  }

  @override
  Future<List<NotificationResult>> sendLowBatteryAlert(
    String userId,
    LocationData location,
    List<TrustedContact> contacts,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return contacts
        .map((c) => NotificationResult(
              contact: c,
              channel: NotificationChannel.push,
              status: NotificationStatus.sent,
            ))
        .toList();
  }
}
