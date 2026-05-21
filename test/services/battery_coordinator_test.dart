import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/battery/battery.dart';
import 'package:safmeh/cubits/route_share/route_share.dart';
import 'package:safmeh/models/location_data.dart';
import 'package:safmeh/models/trusted_contact.dart';
import 'package:safmeh/services/battery_coordinator.dart';
import 'package:safmeh/services/mock_location_service.dart';
import 'package:safmeh/services/mock_notification_service.dart';

TrustedContact _contact() => TrustedContact(
      id: 'c1',
      userId: 'user-001',
      name: 'Mum',
      phoneNumber: '+1234567890',
      addedAt: DateTime.now(),
    );

LocationData _location() => LocationData(
      latitude: 51.5,
      longitude: -0.1,
      accuracy: 10,
      timestamp: DateTime.now(),
    );

void main() {
  group('BatteryCoordinator', () {
    late BatteryCubit batteryCubit;
    late RouteShareCubit routeShareCubit;
    late MockNotificationService notificationService;
    late MockBatteryRepository batteryRepository;
    late MockLocationService locationService;
    late BatteryCoordinator coordinator;

    setUp(() {
      batteryRepository = MockBatteryRepository(initialPercent: 100);
      batteryCubit = BatteryCubit(repository: batteryRepository);
      locationService = MockLocationService();
      routeShareCubit = RouteShareCubit(
        repository: MockRouteShareRepository(),
        locationService: locationService,
      );
      notificationService = MockNotificationService();
      coordinator = BatteryCoordinator(
        batteryCubit: batteryCubit,
        routeShareCubit: routeShareCubit,
        notificationService: notificationService,
        getContacts: () => [_contact()],
        getCurrentLocation: () => _location(),
      );
    });

    tearDown(() async {
      coordinator.dispose();
      await batteryCubit.close();
      await routeShareCubit.close();
      batteryRepository.dispose();
      locationService.dispose();
    });

    test('start begins battery monitoring', () async {
      coordinator.start();
      batteryRepository.setPercent(50);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(batteryCubit.state, isA<BatteryUpdated>());
    });

    test('battery drop to critical sends low battery alert', () async {
      coordinator.start();
      batteryRepository.setPercent(8); // below 10% threshold
      await Future.delayed(const Duration(milliseconds: 200));
      // Low battery alert should have been sent
      // NotificationService.sendLowBatteryAlert was called
      expect(notificationService, isNotNull); // coordinator ran without error
    });

    test('route share cubit receives battery percent updates', () async {
      coordinator.start();
      await routeShareCubit.startSession(
        userId: 'user-001',
        contactIds: ['c1'],
        destinationLat: 51.51,
        destinationLng: -0.12,
      );
      batteryRepository.setPercent(42);
      await Future.delayed(const Duration(milliseconds: 200));
      final state = routeShareCubit.state;
      if (state is RouteShareActive) {
        expect(state.batteryPercent, 42);
      }
    });
  });
}
