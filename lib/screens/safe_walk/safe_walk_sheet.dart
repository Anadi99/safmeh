import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/safe_walk/safe_walk.dart';
import '../../theme/safmeh_theme.dart';
import '../../widgets/soft_button.dart';
import '../../widgets/check_in_prompt.dart';

class SafeWalkSheet extends StatefulWidget {
  const SafeWalkSheet({super.key});

  @override
  State<SafeWalkSheet> createState() => _SafeWalkSheetState();
}

class _SafeWalkSheetState extends State<SafeWalkSheet> {
  Timer? _elapsedTimer;
  Duration _elapsed = Duration.zero;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsed = DateTime.now().difference(_startTime!));
      }
    });
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SafeWalkCubit, SafeWalkState>(
      listener: (context, state) {
        if (state is SafeWalkCheckIn) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => BlocProvider.value(
              value: context.read<SafeWalkCubit>(),
              child: CheckInPrompt(message: state.activity.description),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: SafMehTheme.pureWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: BlocBuilder<SafeWalkCubit, SafeWalkState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
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
                // Status indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: state is SafeWalkEmergency
                            ? SafMehTheme.emergencyRose
                            : SafMehTheme.safeGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state is SafeWalkEmergency
                          ? 'Emergency Mode'
                          : state is SafeWalkCheckIn
                              ? 'Check-in Required'
                              : 'Safe Walk Active',
                      style: TextStyle(
                        color: state is SafeWalkEmergency
                            ? SafMehTheme.emergencyRose
                            : SafMehTheme.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Elapsed time
                Text(
                  _formatDuration(_elapsed),
                  style: const TextStyle(
                    color: SafMehTheme.textMuted,
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                // Current location
                if (state is SafeWalkActive && state.currentLocation != null)
                  Text(
                    '${state.currentLocation!.latitude.toStringAsFixed(4)}, '
                    '${state.currentLocation!.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(
                      color: SafMehTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(height: 28),
                // End session button
                SoftButton(
                  label: 'End Safe Walk',
                  icon: Icons.stop_rounded,
                  color: SafMehTheme.dustyRose,
                  textColor: SafMehTheme.textDark,
                  width: double.infinity,
                  onPressed: () async {
                    await context.read<SafeWalkCubit>().endSession();
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
