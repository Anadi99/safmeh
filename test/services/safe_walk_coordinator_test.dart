import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/safe_walk/safe_walk.dart';
import 'package:safmeh/cubits/sos/sos.dart';
import 'package:safmeh/services/mock_location_service.dart';
import 'package:safmeh/services/mock_motion_detector_service.dart';
import 'package:safmeh/services/safe_walk_coordinator.dart';

void main() {
  group('SafeWalkCoordinator', () {
    late SafeWalkCubit safeWalkCubit;
    late SosCubit sosCubit;
    late MockMotionDetectorService motionService;
    late MockLocationService locationService;
    late SafeWalkCoordinator coordinator;

    setUp(() {
      locationService = MockLocationService();
      safeWalkCubit = SafeWalkCubit(locationService: locationService);
      sosCubit = SosCubit(
        repository: MockSosRepository(),
        locationService: locationService,
        userId: 'user-001',
      );
      motionService = MockMotionDetectorService();
      coordinator = SafeWalkCoordinator(
        safeWalkCubit: safeWalkCubit,
        sosCubit: sosCubit,
        motionService: motionService,
      );
    });

    tearDown(() async {
      coordinator.dispose();
      await safeWalkCubit.close();
      await sosCubit.close();
      locationService.dispose();
      motionService.dispose();
    });

    test('starting safe walk starts motion monitoring', () async {
      coordinator.start();
      await safeWalkCubit.startSession(userId: 'user-001');
      await Future.delayed(const Duration(milliseconds: 100));
      expect(motionService.isMonitoring, isTrue);
    });

    test('ending safe walk stops motion monitoring', () async {
      coordinator.start();
      await safeWalkCubit.startSession(userId: 'user-001');
      await Future.delayed(const Duration(milliseconds: 100));
      await safeWalkCubit.endSession();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(motionService.isMonitoring, isFalse);
    });

    test('fall detection triggers emergency', () async {
      coordinator.start();
      await safeWalkCubit.startSession(userId: 'user-001');
      await Future.delayed(const Duration(milliseconds: 100));
      motionService.simulateFall();
      await Future.delayed(const Duration(milliseconds: 300));
      expect(safeWalkCubit.state, isA<SafeWalkEmergency>());
    });

    test('safe walk emergency auto-activates SOS', () async {
      coordinator.start();
      await safeWalkCubit.startSession(userId: 'user-001');
      await Future.delayed(const Duration(milliseconds: 100));
      safeWalkCubit.triggerEmergency();
      await Future.delayed(const Duration(milliseconds: 300));
      expect(sosCubit.isActive, isTrue);
    });
  });
}
