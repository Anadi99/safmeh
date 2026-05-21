import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/fake_call/fake_call_cubit.dart';
import '../../cubits/fake_call/fake_call_state.dart';
import '../../models/fake_call_config.dart';

class FakeCallScreen extends StatefulWidget {
  const FakeCallScreen({super.key});

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _callTimer;
  Duration _callDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _callTimer?.cancel();
    super.dispose();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _callDuration += const Duration(seconds: 1));
    });
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FakeCallCubit, FakeCallState>(
      listener: (context, state) {
        if (state is FakeCallActive) {
          _startCallTimer();
        }
        if (state is FakeCallEnded || state is FakeCallIdle) {
          _callTimer?.cancel();
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        if (state is FakeCallRinging) {
          return _RingingView(
            config: state.config,
            pulseAnimation: _pulseAnimation,
            onAnswer: () => context.read<FakeCallCubit>().answerCall(),
            onDecline: () {
              context.read<FakeCallCubit>().endCall();
            },
          );
        }
        if (state is FakeCallActive) {
          return _ActiveCallView(
            config: state.config,
            duration: _callDuration,
            formatDuration: _formatDuration,
            onEnd: () => context.read<FakeCallCubit>().endCall(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _RingingView extends StatelessWidget {
  final FakeCallConfig config;
  final Animation<double> pulseAnimation;
  final VoidCallback onAnswer;
  final VoidCallback onDecline;

  const _RingingView({
    required this.config,
    required this.pulseAnimation,
    required this.onAnswer,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Caller avatar
            ScaleTransition(
              scale: pulseAnimation,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3C),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white54,
                  size: 56,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              config.callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'incoming call',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const Spacer(flex: 3),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Decline
                  _CallButton(
                    icon: Icons.call_end_rounded,
                    color: const Color(0xFFFF3B30),
                    label: 'Decline',
                    onTap: onDecline,
                  ),
                  // Answer
                  _CallButton(
                    icon: Icons.call_rounded,
                    color: const Color(0xFF34C759),
                    label: 'Accept',
                    onTap: onAnswer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveCallView extends StatelessWidget {
  final FakeCallConfig config;
  final Duration duration;
  final String Function(Duration) formatDuration;
  final VoidCallback onEnd;

  const _ActiveCallView({
    required this.config,
    required this.duration,
    required this.formatDuration,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF3A3A3C),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white54,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              config.callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatDuration(duration),
              style: const TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const Spacer(flex: 3),
            // End call button
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: _CallButton(
                icon: Icons.call_end_rounded,
                color: const Color(0xFFFF3B30),
                label: 'End',
                onTap: onEnd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _CallButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ],
    );
  }
}
