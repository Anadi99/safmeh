import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/sos/sos.dart';
import 'package:safmeh/models/sos_event.dart';
import 'package:safmeh/services/mock_location_service.dart';

void main() {
  group('SosCubit', () {
    late SosCubit cubit;
    late MockSosRepository repository;
    late MockLocationService locationService;

    setUp(() {
      repository = MockSosRepository();
      locationService = MockLocationService();
      cubit = SosCubit(
        repository: repository,
        locationService: locationService,
        userId: 'user-001',
      );
    });

    tearDown(() async {
      await cubit.close();
      locationService.dispose();
    });

    test('initial state is SosIdle', () {
      expect(cubit.state, isA<SosIdle>());
    });

    test('activate emits SosActive', () async {
      await cubit.activate(SosTrigger.manual);
      expect(cubit.state, isA<SosActive>());
    });

    test('isActive returns true when SosActive', () async {
      await cubit.activate(SosTrigger.manual);
      expect(cubit.isActive, isTrue);
    });

    test('activate sets correct trigger', () async {
      await cubit.activate(SosTrigger.shake);
      final state = cubit.state as SosActive;
      expect(state.event.trigger, SosTrigger.shake);
    });

    test('activate sets sos_active in repository', () async {
      await cubit.activate(SosTrigger.manual);
      expect(repository.isSosActive, isTrue);
    });

    test('deactivate emits SosResolved', () async {
      await cubit.activate(SosTrigger.manual);
      await cubit.deactivate();
      expect(cubit.state, isA<SosResolved>());
    });

    test('deactivate clears sos_active in repository', () async {
      await cubit.activate(SosTrigger.manual);
      await cubit.deactivate();
      expect(repository.isSosActive, isFalse);
    });

    test('resolved event has resolved status', () async {
      await cubit.activate(SosTrigger.manual);
      await cubit.deactivate();
      final state = cubit.state as SosResolved;
      expect(state.event.status, SosStatus.resolved);
    });

    test('deactivate is no-op when not active', () async {
      await cubit.deactivate();
      expect(cubit.state, isA<SosIdle>());
    });
  });
}
