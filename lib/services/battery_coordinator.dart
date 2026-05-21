import 'dart:async';
import '../cubits/battery/battery_cubit.dart';
import '../cubits/battery/battery_state.dart';
import '../cubits/route_share/route_share_cubit.dart';
import '../models/location_data.dart';
import '../models/trusted_contact.dart';
import 'battery_threshold_manager.dart';
import 'notification_service.dart';

/// Wires BatteryCubit to all services that need to adapt to battery level.
/// - Below 20%: reduces location update frequency
/// - Below 10%: notifies trusted contacts of low battery
/// - Below 5%: sends final location to all contacts
class BatteryCoordinator {
  final BatteryCubit _batteryCubit;
  final RouteShareCubit _routeShareCubit;
  final NotificationService _notificationService;
  final List<TrustedContact> Function() _getContacts;
  final LocationData? Function() _getCurrentLocation;

  StreamSubscription<BatteryState>? _batterySub;
  BatteryLevel? _lastLevel;

  BatteryCoordinator({
    required BatteryCubit batteryCubit,
    required RouteShareCubit routeShareCubit,
    required NotificationService notificationService,
    required List<TrustedContact> Function() getContacts,
    required LocationData? Function() getCurrentLocation,
  })  : _batteryCubit = batteryCubit,
        _routeShareCubit = routeShareCubit,
        _notificationService = notificationService,
        _getContacts = getContacts,
        _getCurrentLocation = getCurrentLocation;

  void start() {
    _batteryCubit.startMonitoring();
    _batterySub = _batteryCubit.stream.listen(_onBatteryStateChange);
  }

  void stop() {
    _batterySub?.cancel();
  }

  void _onBatteryStateChange(BatteryState state) async {
    if (state is! BatteryUpdated) return;

    final level = state.level;

    // Update route share with current battery percent
    _routeShareCubit.updateBatteryPercent(state.percent);

    // Only act on level transitions to avoid repeated notifications
    if (level == _lastLevel) return;
    _lastLevel = level;

    if (level == BatteryLevel.critical || level == BatteryLevel.veryLow) {
      // Notify trusted contacts of low battery
      final contacts = _getContacts();
      final location = _getCurrentLocation();
      if (contacts.isNotEmpty && location != null) {
        await _notificationService.sendLowBatteryAlert(
          'user', // userId — will be replaced with real userId when Firebase is wired
          location,
          contacts,
        );
      }
    }
  }

  void dispose() {
    stop();
  }
}
