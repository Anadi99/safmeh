import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/route_share/route_share.dart';
import '../../cubits/trusted_circle/trusted_circle.dart';
import '../../theme/safmeh_theme.dart';
import '../../widgets/soft_button.dart';

class RouteSharePanel extends StatefulWidget {
  const RouteSharePanel({super.key});

  @override
  State<RouteSharePanel> createState() => _RouteSharePanelState();
}

class _RouteSharePanelState extends State<RouteSharePanel> {
  final Set<String> _selectedContactIds = {};
  Duration? _selectedDuration;

  static const _durations = [
    (label: '15 min', duration: Duration(minutes: 15)),
    (label: '30 min', duration: Duration(minutes: 30)),
    (label: '1 hour', duration: Duration(hours: 1)),
  ];

  void _startSharing(String userId) {
    if (_selectedContactIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Select at least one contact.'),
          backgroundColor: SafMehTheme.emergencyRose,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    context.read<RouteShareCubit>().startSession(
          userId: userId,
          contactIds: _selectedContactIds.toList(),
          destinationLat: 0,
          destinationLng: 0,
          duration: _selectedDuration,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: SafMehTheme.pureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: BlocBuilder<RouteShareCubit, RouteShareState>(
        builder: (context, routeState) {
          if (routeState is RouteShareActive) {
            return _ActiveView(session: routeState);
          }
          return _SetupView(
            selectedContactIds: _selectedContactIds,
            selectedDuration: _selectedDuration,
            durations: _durations,
            onDurationSelected: (d) => setState(() => _selectedDuration = d),
            onContactToggled: (id) => setState(() {
              if (_selectedContactIds.contains(id)) {
                _selectedContactIds.remove(id);
              } else {
                _selectedContactIds.add(id);
              }
            }),
            onStart: () => _startSharing(''),
          );
        },
      ),
    );
  }
}

class _SetupView extends StatelessWidget {
  final Set<String> selectedContactIds;
  final Duration? selectedDuration;
  final List<({String label, Duration duration})> durations;
  final ValueChanged<Duration?> onDurationSelected;
  final ValueChanged<String> onContactToggled;
  final VoidCallback onStart;

  const _SetupView({
    required this.selectedContactIds,
    required this.selectedDuration,
    required this.durations,
    required this.onDurationSelected,
    required this.onContactToggled,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: SafMehTheme.dustyRose,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Share your route 🗺️',
          style: TextStyle(
            color: SafMehTheme.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Let trusted people follow your journey.',
          style: TextStyle(color: SafMehTheme.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        // Contact selector
        const Text(
          'Share with',
          style: TextStyle(
            color: SafMehTheme.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<TrustedCircleCubit, TrustedCircleState>(
          builder: (context, state) {
            if (state is TrustedCircleLoaded && state.contacts.isNotEmpty) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.contacts.map((c) {
                  final selected = selectedContactIds.contains(c.id);
                  return GestureDetector(
                    onTap: () => onContactToggled(c.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? SafMehTheme.blushPink
                            : SafMehTheme.palePink,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? SafMehTheme.deepPink
                              : SafMehTheme.dustyRose,
                        ),
                      ),
                      child: Text(
                        c.name,
                        style: TextStyle(
                          color: selected
                              ? SafMehTheme.pureWhite
                              : SafMehTheme.textDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
            return const Text(
              'No contacts yet. Add some to your circle first.',
              style: TextStyle(color: SafMehTheme.textMuted, fontSize: 13),
            );
          },
        ),
        const SizedBox(height: 20),
        // Duration selector
        const Text(
          'Duration',
          style: TextStyle(
            color: SafMehTheme.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            // "Until arrival" chip
            GestureDetector(
              onTap: () => onDurationSelected(null),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedDuration == null
                      ? SafMehTheme.blushPink
                      : SafMehTheme.palePink,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selectedDuration == null
                        ? SafMehTheme.deepPink
                        : SafMehTheme.dustyRose,
                  ),
                ),
                child: Text(
                  'Until arrival',
                  style: TextStyle(
                    color: selectedDuration == null
                        ? SafMehTheme.pureWhite
                        : SafMehTheme.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            ...durations.map((d) {
              final selected = selectedDuration == d.duration;
              return GestureDetector(
                onTap: () => onDurationSelected(d.duration),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? SafMehTheme.blushPink
                        : SafMehTheme.palePink,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? SafMehTheme.deepPink
                          : SafMehTheme.dustyRose,
                    ),
                  ),
                  child: Text(
                    d.label,
                    style: TextStyle(
                      color: selected
                          ? SafMehTheme.pureWhite
                          : SafMehTheme.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 24),
        SoftButton(
          label: 'Start Sharing',
          icon: Icons.share_location_rounded,
          width: double.infinity,
          onPressed: onStart,
        ),
      ],
    );
  }
}

class _ActiveView extends StatelessWidget {
  final RouteShareActive session;
  const _ActiveView({required this.session});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: SafMehTheme.dustyRose,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: SafMehTheme.safeGreen,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Sharing your route',
              style: TextStyle(
                color: SafMehTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (session.etaString != null)
          Text(
            session.etaString!,
            style: const TextStyle(
              color: SafMehTheme.textMuted,
              fontSize: 14,
            ),
          ),
        if (session.batteryPercent != null) ...[
          const SizedBox(height: 4),
          Text(
            'Battery: ${session.batteryPercent}%',
            style: const TextStyle(
                color: SafMehTheme.textMuted, fontSize: 13),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          'Sharing with ${session.session.contactIds.length} contact(s)',
          style: const TextStyle(
              color: SafMehTheme.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 24),
        SoftButton(
          label: 'Stop Sharing',
          icon: Icons.stop_rounded,
          color: SafMehTheme.dustyRose,
          textColor: SafMehTheme.textDark,
          width: double.infinity,
          onPressed: () async {
            await context.read<RouteShareCubit>().endSession();
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
