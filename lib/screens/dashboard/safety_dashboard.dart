import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/safe_walk/safe_walk.dart';
import '../../cubits/sos/sos.dart';
import '../../cubits/battery/battery.dart';
import '../../cubits/fake_call/fake_call.dart';
import '../../models/fake_call_config.dart';
import '../../models/sos_event.dart';
import '../../screens/safe_walk/safe_walk_sheet.dart';
import '../../screens/route_share/route_share_panel.dart';
import '../../screens/fake_call/fake_call_screen.dart';
import '../../theme/safmeh_theme.dart';

class SafetyDashboard extends StatelessWidget {
  const SafetyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SafMehTheme.softWhite,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(child: _DashboardHeader()),
            // Main grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // SOS button — full width, prominent
                  _SosCard(),
                  const SizedBox(height: 16),
                  // Safe Walk — full width
                  _SafeWalkCard(),
                  const SizedBox(height: 16),
                  // 2-column grid: Fake Call + Route Share
                  Row(
                    children: [
                      Expanded(child: _FakeCallCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _RouteShareCard()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 2-column grid: Comfort + Trusted Circle
                  Row(
                    children: [
                      Expanded(child: _ComfortCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _TrustedCircleCard()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Pretend Mode — full width
                  _PretendModeCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi there 🌸',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: SafMehTheme.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'You are safe.',
                  style: TextStyle(color: SafMehTheme.textMuted, fontSize: 14),
                ),
              ],
            ),
          ),
          // Battery indicator
          BlocBuilder<BatteryCubit, BatteryState>(
            builder: (context, state) {
              if (state is BatteryUpdated) {
                return _BatteryChip(percent: state.percent);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _BatteryChip extends StatelessWidget {
  final int percent;
  const _BatteryChip({required this.percent});

  @override
  Widget build(BuildContext context) {
    final color = percent <= 10
        ? SafMehTheme.emergencyRose
        : percent <= 20
            ? SafMehTheme.warningPeach
            : SafMehTheme.safeGreen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.battery_std_rounded, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            '$percent%',
            style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─── SOS Card ────────────────────────────────────────────────────────────────

class _SosCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SosCubit, SosState>(
      builder: (context, state) {
        final isActive = state is SosActive;
        return GestureDetector(
          onTap: () {
            if (isActive) {
              context.read<SosCubit>().deactivate();
            } else {
              context.read<SosCubit>().activate(SosTrigger.manual);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isActive
                    ? [SafMehTheme.emergencyRose, const Color(0xFFFF6B9D)]
                    : [SafMehTheme.blushPink, SafMehTheme.deepPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: SafMehTheme.blushPink.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isActive ? Icons.stop_rounded : Icons.sos_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive ? 'SOS Active' : 'Silent SOS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        isActive ? 'Tap to deactivate' : 'Tap to activate silently',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Safe Walk Card ───────────────────────────────────────────────────────────

class _SafeWalkCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SafeWalkCubit, SafeWalkState>(
      builder: (context, state) {
        final isActive = state is SafeWalkActive || state is SafeWalkCheckIn || state is SafeWalkEmergency;
        return GestureDetector(
          onTap: () {
            if (isActive) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider.value(
                  value: context.read<SafeWalkCubit>(),
                  child: const SafeWalkSheet(),
                ),
              );
            } else {
              context.read<SafeWalkCubit>().startSession();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider.value(
                  value: context.read<SafeWalkCubit>(),
                  child: const SafeWalkSheet(),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SafMehTheme.pureWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive ? SafMehTheme.deepPink : SafMehTheme.dustyRose,
                width: isActive ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: SafMehTheme.blushPink.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isActive ? SafMehTheme.deepPink : SafMehTheme.palePink,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_walk_rounded,
                    color: isActive ? Colors.white : SafMehTheme.deepPink,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive ? 'Safe Walk Active' : 'Safe Walk',
                        style: const TextStyle(
                          color: SafMehTheme.textDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        isActive ? 'Tap to manage' : 'Start protected journey',
                        style: const TextStyle(color: SafMehTheme.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isActive ? SafMehTheme.deepPink : SafMehTheme.textMuted,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Small Feature Cards ──────────────────────────────────────────────────────

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SafMehTheme.pureWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: SafMehTheme.dustyRose,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: SafMehTheme.blushPink.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SafMehTheme.palePink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: SafMehTheme.deepPink,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: SafMehTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: SafMehTheme.textMuted, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _FakeCallCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FeatureCard(
      icon: Icons.phone_rounded,
      title: 'Fake Call',
      subtitle: 'Escape any situation',
      onTap: () {
        context.read<FakeCallCubit>().triggerInstant(
              const FakeCallConfig(
                callerName: 'Mum',
                ringtonePath: '',
              ),
            );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<FakeCallCubit>(),
              child: const FakeCallScreen(),
            ),
          ),
        );
      },
    );
  }
}

class _RouteShareCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FeatureCard(
      icon: Icons.share_location_rounded,
      title: 'Route Share',
      subtitle: 'Share your journey',
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<SafeWalkCubit>()),
            ],
            child: const RouteSharePanel(),
          ),
        );
      },
    );
  }
}

class _ComfortCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FeatureCard(
      icon: Icons.favorite_rounded,
      title: 'Comfort',
      subtitle: 'Notes & affirmations',
      onTap: () => Navigator.of(context).pushNamed('/comfort'),
    );
  }
}

class _TrustedCircleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FeatureCard(
      icon: Icons.people_rounded,
      title: 'My Circle',
      subtitle: 'Trusted contacts',
      onTap: () => Navigator.of(context).pushNamed('/trusted-circle'),
    );
  }
}

class _PretendModeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FeatureCard(
      icon: Icons.visibility_off_rounded,
      title: 'Pretend Mode',
      subtitle: 'Disguise this app',
      onTap: () => Navigator.of(context).pushNamed('/pretend-mode'),
    );
  }
}
