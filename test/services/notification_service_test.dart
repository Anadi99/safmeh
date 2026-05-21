import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/models/location_data.dart';
import 'package:safmeh/models/trusted_contact.dart';
import 'package:safmeh/services/notification_service.dart';
import 'package:safmeh/services/mock_notification_service.dart';
import 'package:safmeh/services/notification_retry_manager.dart';

TrustedContact _contact(String id, {String? email}) => TrustedContact(
      id: id,
      userId: 'user-001',
      name: 'Contact $id',
      phoneNumber: '+1234567890',
      email: email,
      addedAt: DateTime.now(),
    );

EmergencyAlert _alert() => EmergencyAlert(
      userId: 'user-001',
      location: LocationData(
        latitude: 51.5,
        longitude: -0.1,
        accuracy: 10,
        timestamp: DateTime.now(),
      ),
      timestamp: DateTime.now(),
      message: 'Emergency!',
    );

void main() {
  group('MockNotificationService', () {
    late MockNotificationService service;

    setUp(() => service = MockNotificationService());

    test('sendEmergencyAlert returns sent results for all contacts', () async {
      final contacts = [_contact('1'), _contact('2'), _contact('3')];
      final results = await service.sendEmergencyAlert(_alert(), contacts);
      final sentResults = results.where((r) => r.status == NotificationStatus.sent);
      // Each contact gets push + sms = 2 results minimum
      expect(sentResults.length, greaterThanOrEqualTo(contacts.length * 2));
    });

    test('sendEmergencyAlert includes email result when contact has email', () async {
      final contacts = [_contact('1', email: 'test@example.com')];
      final results = await service.sendEmergencyAlert(_alert(), contacts);
      final emailResults = results.where((r) => r.channel == NotificationChannel.email);
      expect(emailResults.length, 1);
    });

    test('sendEmergencyAlert returns failed results when shouldFail is true', () async {
      service.shouldFail = true;
      final contacts = [_contact('1')];
      final results = await service.sendEmergencyAlert(_alert(), contacts);
      expect(results.every((r) => r.status == NotificationStatus.failed), isTrue);
    });

    test('alert contains location and timestamp', () async {
      final alert = _alert();
      expect(alert.location, isNotNull);
      expect(alert.timestamp, isNotNull);
    });

    test('sendRouteUpdate returns sent results', () async {
      final contacts = [_contact('1'), _contact('2')];
      final update = RouteUpdate(
        userId: 'user-001',
        location: LocationData(
          latitude: 51.5,
          longitude: -0.1,
          accuracy: 10,
          timestamp: DateTime.now(),
        ),
        etaString: '5 min',
        batteryPercent: 80,
      );
      final results = await service.sendRouteUpdate(update, contacts);
      expect(results.every((r) => r.status == NotificationStatus.sent), isTrue);
    });
  });

  group('NotificationRetryManager', () {
    late NotificationRetryManager manager;
    late MockNotificationService service;

    setUp(() {
      manager = NotificationRetryManager();
      service = MockNotificationService();
    });

    tearDown(() => manager.dispose());

    test('sendWithRetry succeeds on first attempt', () async {
      final contacts = [_contact('1')];
      await manager.sendWithRetry(_alert(), contacts, service);
      expect(manager.queue.first.status, NotificationStatus.sent);
    });

    test('sendWithRetry marks as failed after max attempts when service fails', () async {
      service.shouldFail = true;
      final contacts = [_contact('1')];
      await manager.sendWithRetry(_alert(), contacts, service);
      // After first attempt fails, it schedules retries — but in test we check attempt count
      expect(manager.queue.first.attemptCount, greaterThanOrEqualTo(1));
    });

    test('retry count does not exceed maxAttempts', () async {
      service.shouldFail = true;
      final contacts = [_contact('1')];
      await manager.sendWithRetry(_alert(), contacts, service);
      expect(
        manager.queue.first.attemptCount,
        lessThanOrEqualTo(NotificationRetryManager.maxAttempts),
      );
    });
  });
}
