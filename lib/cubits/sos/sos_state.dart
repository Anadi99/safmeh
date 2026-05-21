import 'package:equatable/equatable.dart';
import '../../models/sos_event.dart';
import '../../models/location_data.dart';

abstract class SosState extends Equatable {
  const SosState();
  @override
  List<Object?> get props => [];
}

class SosIdle extends SosState {
  const SosIdle();
}

class SosActive extends SosState {
  final SosEvent event;
  final LocationData? currentLocation;
  const SosActive({required this.event, this.currentLocation});
  @override
  List<Object?> get props => [event, currentLocation];
}

class SosDeactivating extends SosState {
  final SosEvent event;
  const SosDeactivating(this.event);
  @override
  List<Object?> get props => [event];
}

class SosResolved extends SosState {
  final SosEvent event;
  const SosResolved(this.event);
  @override
  List<Object?> get props => [event];
}

class SosError extends SosState {
  final String message;
  const SosError(this.message);
  @override
  List<Object?> get props => [message];
}
