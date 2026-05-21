import 'package:equatable/equatable.dart';
import '../../models/route_share_session.dart';
import '../../models/location_data.dart';

abstract class RouteShareState extends Equatable {
  const RouteShareState();
  @override
  List<Object?> get props => [];
}

class RouteShareIdle extends RouteShareState {
  const RouteShareIdle();
}

class RouteShareActive extends RouteShareState {
  final RouteShareSession session;
  final LocationData? currentLocation;
  final String? etaString;
  final int? batteryPercent;

  const RouteShareActive({
    required this.session,
    this.currentLocation,
    this.etaString,
    this.batteryPercent,
  });

  @override
  List<Object?> get props => [session, currentLocation, etaString, batteryPercent];
}

class RouteShareEnded extends RouteShareState {
  final RouteShareSession session;
  const RouteShareEnded(this.session);
  @override
  List<Object?> get props => [session];
}

class RouteShareError extends RouteShareState {
  final String message;
  const RouteShareError(this.message);
  @override
  List<Object?> get props => [message];
}
