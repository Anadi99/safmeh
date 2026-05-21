import '../models/trusted_contact.dart';
import '../models/location_data.dart';

enum NotificationChannel { push, sms, email }
enum NotificationStatus { pending, sent, failed }

class EmergencyAlert {
  final String userId;
  final LocationData location;
  final DateTime timestamp;
  final String message;

  const EmergencyAlert({
    required this.userId,
    required this.location,
    required this.timestamp,
    required this.message,
  });
}

class RouteUpdate {
  final String userId;
  final LocationData location;
  final String? etaString;
  final int? batteryPercent;

  const RouteUpdate({
    required this.userId,
    required this.location,
    this.etaString,
    this.batteryPercent,
  });
}

class NotificationResult {
  final TrustedContact contact;
  final NotificationChannel channel;
  final NotificationStatus status;
  final String? errorMessage;

  const NotificationResult({
    required this.contact,
    required this.channel,
    required this.status,
    this.errorMessage,
  });
}

abstract class NotificationService {
  Future<List<NotificationResult>> sendEmergencyAlert(
    EmergencyAlert alert,
    List<TrustedContact> contacts,
  );

  Future<List<NotificationResult>> sendRouteUpdate(
    RouteUpdate update,
    List<TrustedContact> contacts,
  );

  Future<List<NotificationResult>> sendLowBatteryAlert(
    String userId,
    LocationData location,
    List<TrustedContact> contacts,
  );
}
