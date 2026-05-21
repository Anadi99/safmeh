import 'package:equatable/equatable.dart';
import '../../models/safe_walk_session.dart';
import '../../models/location_data.dart';
import '../../services/unusual_activity_detector.dart';

abstract class SafeWalkState extends Equatable {
  const SafeWalkState();
  @override
  List<Object?> get props => [];
}

class SafeWalkIdle extends SafeWalkState {
  const SafeWalkIdle();
}

class SafeWalkActive extends SafeWalkState {
  final SafeWalkSession session;
  final LocationData? currentLocation;
  const SafeWalkActive({required this.session, this.currentLocation});
  @override
  List<Object?> get props => [session, currentLocation];
}

class SafeWalkCheckIn extends SafeWalkState {
  final SafeWalkSession session;
  final LocationData? currentLocation;
  final UnusualActivity activity;
  final DateTime promptedAt;
  const SafeWalkCheckIn({
    required this.session,
    this.currentLocation,
    required this.activity,
    required this.promptedAt,
  });
  @override
  List<Object?> get props => [session, currentLocation, activity, promptedAt];
}

class SafeWalkEmergency extends SafeWalkState {
  final SafeWalkSession session;
  final LocationData? currentLocation;
  const SafeWalkEmergency({required this.session, this.currentLocation});
  @override
  List<Object?> get props => [session, currentLocation];
}

class SafeWalkEnded extends SafeWalkState {
  final SafeWalkSession session;
  const SafeWalkEnded(this.session);
  @override
  List<Object?> get props => [session];
}

class SafeWalkError extends SafeWalkState {
  final String message;
  const SafeWalkError(this.message);
  @override
  List<Object?> get props => [message];
}
