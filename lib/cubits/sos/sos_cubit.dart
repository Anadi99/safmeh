import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../models/sos_event.dart';
import '../../models/location_data.dart';
import '../../services/location_service.dart';
import 'sos_state.dart';

abstract class SosRepository {
  Future<SosEvent> createSosEvent(SosEvent event);
  Future<SosEvent> resolveSosEvent(String eventId);
  Future<void> setSosActive(String userId, bool active);
}

class SosCubit extends Cubit<SosState> {
  final SosRepository _repository;
  final LocationService _locationService;
  final String userId;
  final _uuid = const Uuid();

  StreamSubscription<LocationData>? _locationSub;

  SosCubit({
    required SosRepository repository,
    required LocationService locationService,
    required this.userId,
  })  : _repository = repository,
        _locationService = locationService,
        super(const SosIdle());

  bool get isActive => state is SosActive;

  Future<void> activate(SosTrigger trigger) async {
    if (state is SosActive) return;
    try {
      final location = await _locationService.getCurrentLocation(highAccuracy: true);
      final event = SosEvent(
        id: _uuid.v4(),
        userId: userId,
        trigger: trigger,
        activatedAt: DateTime.now(),
        locationAtActivation: location,
        status: SosStatus.active,
      );
      final saved = await _repository.createSosEvent(event);
      await _repository.setSosActive(userId, true);
      _locationSub = _locationService.locationStream.listen((loc) {
        if (state is SosActive) {
          emit(SosActive(event: (state as SosActive).event, currentLocation: loc));
        }
      });
      emit(SosActive(event: saved, currentLocation: location));
    } catch (e) {
      emit(SosError('Failed to activate SOS: $e'));
    }
  }

  Future<void> deactivate() async {
    final current = state;
    if (current is! SosActive) return;
    emit(SosDeactivating(current.event));
    try {
      await _locationSub?.cancel();
      _locationSub = null;
      final resolved = await _repository.resolveSosEvent(current.event.id);
      await _repository.setSosActive(userId, false);
      emit(SosResolved(resolved));
    } catch (e) {
      emit(SosError('Failed to deactivate SOS: $e'));
    }
  }

  @override
  Future<void> close() {
    _locationSub?.cancel();
    return super.close();
  }
}
