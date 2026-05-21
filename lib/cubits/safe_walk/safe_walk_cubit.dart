import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../models/safe_walk_session.dart';
import '../../models/location_data.dart';
import '../../services/location_service.dart';
import '../../services/unusual_activity_detector.dart';
import 'safe_walk_state.dart';

class SafeWalkCubit extends Cubit<SafeWalkState> {
  final LocationService _locationService;
  final UnusualActivityDetector _activityDetector;
  final _uuid = const Uuid();

  StreamSubscription<LocationData>? _locationSub;
  Timer? _checkInTimer;
  SafeWalkSession? _currentSession;
  LocationData? _currentLocation;

  SafeWalkCubit({
    required LocationService locationService,
    UnusualActivityDetector? activityDetector,
  })  : _locationService = locationService,
        _activityDetector = activityDetector ?? UnusualActivityDetector(),
        super(const SafeWalkIdle());

  Future<void> startSession({
    String userId = '',
    double? destinationLat,
    double? destinationLng,
  }) async {
    if (state is SafeWalkActive) return;

    final session = SafeWalkSession(
      id: _uuid.v4(),
      userId: userId,
      startTime: DateTime.now(),
      status: SafeWalkStatus.active,
      destinationLat: destinationLat,
      destinationLng: destinationLng,
    );
    _currentSession = session;
    _activityDetector.reset();

    await _locationService.startBackgroundTracking(
      const LocationSettings(intervalMs: 10000),
    );

    _locationSub = _locationService.locationStream.listen(_onLocationUpdate);
    emit(SafeWalkActive(session: session));
  }

  void _onLocationUpdate(LocationData location) {
    _currentLocation = location;
    final session = _currentSession;
    if (session == null) return;

    // Update session location history
    final updated = session.copyWith(
      locationHistory: [...session.locationHistory, location],
    );
    _currentSession = updated;

    // Check for unusual activity (only when actively walking, not during check-in)
    if (state is SafeWalkActive) {
      LocationData? plannedPoint;
      if (session.destinationLat != null && session.destinationLng != null) {
        plannedPoint = LocationData(
          latitude: session.destinationLat!,
          longitude: session.destinationLng!,
          accuracy: 0,
          timestamp: DateTime.now(),
        );
      }

      final activity = _activityDetector.check(location, plannedRoutePoint: plannedPoint);
      if (activity != null) {
        _triggerCheckIn(activity);
      } else {
        emit(SafeWalkActive(session: updated, currentLocation: location));
      }
    }
  }

  void _triggerCheckIn(UnusualActivity activity) {
    final session = _currentSession;
    if (session == null) return;

    emit(SafeWalkCheckIn(
      session: session,
      currentLocation: _currentLocation,
      activity: activity,
      promptedAt: DateTime.now(),
    ));

    // Auto-trigger emergency after 15 seconds if no response
    _checkInTimer?.cancel();
    _checkInTimer = Timer(const Duration(seconds: 15), () {
      if (state is SafeWalkCheckIn) {
        _triggerEmergency();
      }
    });
  }

  /// User confirms they are safe — dismiss check-in prompt.
  void confirmSafe() {
    _checkInTimer?.cancel();
    final session = _currentSession;
    if (session == null) return;
    _activityDetector.reset();
    emit(SafeWalkActive(session: session, currentLocation: _currentLocation));
  }

  void _triggerEmergency() {
    _checkInTimer?.cancel();
    final session = _currentSession;
    if (session == null) return;
    final emergency = session.copyWith(status: SafeWalkStatus.emergency);
    _currentSession = emergency;
    emit(SafeWalkEmergency(session: emergency, currentLocation: _currentLocation));
  }

  /// Manually trigger emergency (e.g. from SOS button during walk).
  void triggerEmergency() => _triggerEmergency();

  Future<void> endSession() async {
    _checkInTimer?.cancel();
    await _locationSub?.cancel();
    await _locationService.stopBackgroundTracking();

    final session = _currentSession;
    if (session == null) {
      emit(const SafeWalkIdle());
      return;
    }

    final ended = session.copyWith(
      status: SafeWalkStatus.ended,
      endTime: DateTime.now(),
    );
    _currentSession = null;
    _activityDetector.reset();
    emit(SafeWalkEnded(ended));
  }

  @override
  Future<void> close() {
    _checkInTimer?.cancel();
    _locationSub?.cancel();
    return super.close();
  }
}
