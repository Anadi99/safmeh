import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/route_share/route_share.dart';
import 'package:safmeh/models/route_share_session.dart';
import 'package:safmeh/services/mock_location_service.dart';

void main() {
  group('RouteShareCubit', () {
    late RouteShareCubit cubit;
    late MockRouteShareRepository repository;
    late MockLocationService locationService;

    setUp(() {
      repository = MockRouteShareRepository();
      locationService = MockLocationService();
      cubit = RouteShareCubit(
        repository: repository,
        locationService: locationService,
      );
    });

    tearDown(() async {
      await cubit.close();
      locationService.dispose();
    });

    test('initial state is RouteShareIdle', () {
      expect(cubit.state, isA<RouteShareIdle>());
    });

    test('startSession emits RouteShareActive', () async {
      await cubit.startSession(
        userId: 'user-001',
        contactIds: ['contact-1'],
        destinationLat: 51.51,
        destinationLng: -0.12,
      );
      expect(cubit.state, isA<RouteShareActive>());
    });

    test('session has correct contactIds', () async {
      await cubit.startSession(
        userId: 'user-001',
        contactIds: ['c1', 'c2'],
        destinationLat: 51.51,
        destinationLng: -0.12,
      );
      final state = cubit.state as RouteShareActive;
      expect(state.session.contactIds, ['c1', 'c2']);
    });

    test('endSession emits RouteShareEnded', () async {
      await cubit.startSession(
        userId: 'user-001',
        contactIds: ['contact-1'],
        destinationLat: 51.51,
        destinationLng: -0.12,
      );
      await cubit.endSession();
      expect(cubit.state, isA<RouteShareEnded>());
    });

    test('ended session has ended status', () async {
      await cubit.startSession(
        userId: 'user-001',
        contactIds: ['contact-1'],
        destinationLat: 51.51,
        destinationLng: -0.12,
      );
      await cubit.endSession();
      final state = cubit.state as RouteShareEnded;
      expect(state.session.status, RouteShareStatus.ended);
    });

    test('updateBatteryPercent updates state', () async {
      await cubit.startSession(
        userId: 'user-001',
        contactIds: ['contact-1'],
        destinationLat: 51.51,
        destinationLng: -0.12,
      );
      cubit.updateBatteryPercent(42);
      final state = cubit.state as RouteShareActive;
      expect(state.batteryPercent, 42);
    });

    test('timer expiry ends session', () async {
      await cubit.startSession(
        userId: 'user-001',
        contactIds: ['contact-1'],
        destinationLat: 51.51,
        destinationLng: -0.12,
        duration: const Duration(milliseconds: 200),
      );
      await Future.delayed(const Duration(milliseconds: 400));
      expect(cubit.state, isA<RouteShareEnded>());
    });
  });
}
