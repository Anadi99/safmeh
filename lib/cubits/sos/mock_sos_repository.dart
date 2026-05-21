import '../../models/sos_event.dart';
import 'sos_cubit.dart';

class MockSosRepository implements SosRepository {
  final Map<String, SosEvent> _events = {};
  bool _sosActive = false;

  bool get isSosActive => _sosActive;

  @override
  Future<SosEvent> createSosEvent(SosEvent event) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _events[event.id] = event;
    return event;
  }

  @override
  Future<SosEvent> resolveSosEvent(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final event = _events[eventId];
    if (event == null) throw Exception('SOS event not found: $eventId');
    final resolved = event.copyWith(
      status: SosStatus.resolved,
      deactivatedAt: DateTime.now(),
    );
    _events[eventId] = resolved;
    return resolved;
  }

  @override
  Future<void> setSosActive(String userId, bool active) async {
    _sosActive = active;
  }
}
