import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/safe_walk/safe_walk.dart';
import '../theme/safmeh_theme.dart';

class CheckInPrompt extends StatefulWidget {
  final String message;
  const CheckInPrompt({super.key, required this.message});

  @override
  State<CheckInPrompt> createState() => _CheckInPromptState();
}

class _CheckInPromptState extends State<CheckInPrompt>
    with SingleTickerProviderStateMixin {
  static const int _totalSeconds = 15;
  int _remaining = _totalSeconds;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) {
        t.cancel();
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _confirmSafe() {
    _timer?.cancel();
    context.read<SafeWalkCubit>().confirmSafe();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remaining / _totalSeconds;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: SafMehTheme.pureWhite,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: SafMehTheme.blushPink.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pulsing icon
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + _pulseController.value * 0.1,
                  child: child,
                );
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: SafMehTheme.palePink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: SafMehTheme.deepPink,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Are you okay? 🌸',
              style: TextStyle(
                color: SafMehTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: SafMehTheme.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 20),
            // Countdown progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: SafMehTheme.palePink,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _remaining <= 5 ? SafMehTheme.emergencyRose : SafMehTheme.blushPink,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_remaining seconds',
              style: TextStyle(
                color: _remaining <= 5 ? SafMehTheme.emergencyRose : SafMehTheme.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmSafe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SafMehTheme.blushPink,
                  foregroundColor: SafMehTheme.pureWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: const Text(
                  "I'm Safe 💕",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
