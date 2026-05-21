import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../models/route_share_session.dart';
import '../../models/location_data.dart';
import '../../services/location_service.dart';
import '../../services/unusual_activity_detector.dart';
import 'route_share_state.dart';

abstract class RouteShareRepository {
  Future<RouteShareSession> createSession(RouteShareSession session);
  Future<void> updateSession(RouteShareSession session);
  Future<void> endSession(String sessionId);
}

class RouteShareCubit extends Cubit<RouteShareState> {
  final RouteShareRepository _repository;
  final LocationService _locationService;
  final _uuid = const Uuid();

  StreamSubscription<LocationData>? _locationSub;
  Timer? _etaTimer;
  Timer? _expiryTimer;
  RouteShareSession? _currentSession;

  RouteShareCubit({
    required RouteShareRepository repository,
    required LocationService locationService,
  })  : _repository = repository,
        _locationService = locationService,
        super(const RouteShareIdle());

  Future<void> startSession({
    required String userId,
    required List<String> contactIds,
    required double destinationLat,
    required double destinationLng,
    Duration? duration,
    int? batteryPercent,
  }) async {
    try {
      final session = RouteShareSession(
        id: _uuid.v4(),
        userId: userId,
        contactIds: contactIds,
        destinationLat: destinationLat,
        destinationLng: destinationLng,
        startTime: DateTime.now(),
        expiresAt: duration != null ? DateTime.now().add(duration) : null,
        status: RouteShareStatus.active,
        batteryPercent: batteryPercent,
      );

      final saved = await _repository.createSession(session);
      _currentSession = saved;

      // Start location updates
      await _locationService.startBackgroundTracking(
        const LocationSettings(intervalMs: 10000),
      );
      _locationSub = _locationService.locationStream.listen(_onLocationUpdate);

      // Update ETA every 30 seconds
      _etaTimer = Timer.periodic(const Duration(seconds: 30), (_) => _updateEta());

      // Set expiry timer if duration provided
      if (duration != null) {
        _expiryTimer = Timer(duration, () => endSession(reason: 'timer'));
      }

      emit(RouteShareActive(
        session: saved,
        batteryPercent: batteryPercent,
        etaString: _calculateEta(null, destinationLat, destinationLng),
      ));
    } catch (e) {
      emit(RouteShareError('Failed to start route sharing: $e'));
    }
  }

  void _onLocationUpdate(LocationData location) {
    final session = _currentSession;
    if (session == null || state is! RouteShareActive) return;

    final updated = session.copyWith(lastLocation: location);
    _currentSession = updated;

    // Check if arrived at destination (within 50 meters)
    final distance = UnusualActivityDetector.distanceBetween(
      location.latitude,
      location.longitude,
      session.destinationLat,
      session.destinationLng,
    );

    if (distance <= 50) {
      endSession(reason: 'arrived');
      return;
    }

    final currentState = state as RouteShareActive;
    emit(RouteShareActive(
      session: updated,
      currentLocation: location,
      etaString: currentState.etaString,
      batteryPercent: currentState.batteryPercent,
    ));
  }

  void _updateEta() {
    final session = _currentSession;
    final currentState = state;
    if (session == null || currentState is! RouteShareActive) return;

    final eta = _calculateEta(
      session.lastLocation,
      session.destinationLat,
      session.destinationLng,
    );

    emit(RouteShareActive(
      session: session,
      currentLocation: currentState.currentLocation,
      etaString: eta,
      batteryPercent: currentState.batteryPercent,
    ));
  }

  String? _calculateEta(
    LocationData? current,
    double destLat,
    double destLng,
  ) {
    if (current == null) return null;
    final distance = UnusualActivityDetector.distanceBetween(
      current.latitude,
      current.longitude,
      destLat,
      destLng,
    );
    // Assume average walking speed of 1.4 m/s
    final seconds = (distance / 1.4).round();
    final minutes = (seconds / 60).ceil();
    if (minutes <= 1) return 'Almost there';
    return '$minutes min away';
  }

  Future<void> endSession({String reason = 'manual'}) async {
    _etaTimer?.cancel();
    _expiryTimer?.cancel();
    await _locationSub?.cancel();
    await _locationService.stopBackgroundTracking();

    final session = _currentSession;
    if (session == null) {
      emit(const RouteShareIdle());
      return;
    }

    try {
      await _repository.endSession(session.id);
      final ended = session.copyWith(status: RouteShareStatus.ended);
      _currentSession = null;
      emit(RouteShareEnded(ended));
    } catch (e) {
      emit(RouteShareError('Failed to end session: $e'));
    }
  }

  void updateBatteryPercent(int percent) {
    final currentState = state;
    if (currentState is RouteShareActive) {
      final updated = _currentSession?.copyWith(batteryPercent: percent);
      if (updated != null) _currentSession = updated;
      emit(RouteShareActive(
        session: _currentSession ?? currentState.session,
        currentLocation: currentState.currentLocation,
        etaString: currentState.etaString,
        batteryPercent: percent,
      ));
    }
  }

  @override
  Future<void> close() {
    _etaTimer?.cancel();
    _expiryTimer?.cancel();
    _locationSub?.cancel();
    return super.close();
  }
}
