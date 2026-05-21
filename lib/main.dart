import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/auth/auth.dart';
import 'cubits/battery/battery.dart';
import 'cubits/comfort/comfort.dart';
import 'cubits/fake_call/fake_call.dart';
import 'cubits/pretend_mode/pretend_mode.dart';
import 'cubits/route_share/route_share.dart';
import 'cubits/safe_walk/safe_walk.dart';
import 'cubits/sos/sos.dart';
import 'cubits/trusted_circle/trusted_circle.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/comfort/comfort_screen.dart';
import 'screens/dashboard/safety_dashboard.dart';
import 'screens/pretend_mode/pretend_mode_screen.dart';
import 'screens/trusted_circle/trusted_circle_screen.dart';
import 'services/mock_location_service.dart';
import 'theme/safmeh_theme.dart';
import 'widgets/sos_overlay.dart';

void main() {
  runApp(const SafMehApp());
}

class SafMehApp extends StatelessWidget {
  const SafMehApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locationService = MockLocationService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(MockAuthRepository())),
        BlocProvider(
          create: (_) => SosCubit(
            repository: MockSosRepository(),
            locationService: locationService,
            userId: '',
          ),
        ),
        BlocProvider(
          create: (_) => SafeWalkCubit(locationService: locationService),
        ),
        BlocProvider(
          create: (_) => BatteryCubit(repository: MockBatteryRepository()),
        ),
        BlocProvider(
          create: (_) => TrustedCircleCubit(
            MockTrustedCircleRepository(),
            userId: '',
          ),
        ),
        BlocProvider(
          create: (_) => ComfortCubit(
            repository: MockComfortRepository(),
            userId: '',
          ),
        ),
        BlocProvider(create: (_) => FakeCallCubit()),
        BlocProvider(
          create: (_) => RouteShareCubit(
            repository: MockRouteShareRepository(),
            locationService: locationService,
          ),
        ),
        BlocProvider(create: (_) => PretendModeCubit()),
      ],
      child: MaterialApp(
        title: 'SafMeh',
        debugShowCheckedModeBanner: false,
        theme: SafMehTheme.theme,
        builder: (context, child) => SosOverlay(child: child ?? const SizedBox()),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/dashboard': (_) => const SafetyDashboard(),
          '/comfort': (_) => const ComfortScreen(),
          '/trusted-circle': (_) => const TrustedCircleScreen(),
          '/pretend-mode': (_) => const PretendModeScreen(),
        },
      ),
    );
  }
}
