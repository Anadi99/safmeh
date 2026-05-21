import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/sos/sos.dart';
import '../theme/safmeh_theme.dart';

/// Invisible overlay that wraps the app during Silent SOS.
/// Shows only a tiny subtle dot indicator — nothing alarming or obvious.
class SosOverlay extends StatelessWidget {
  final Widget child;

  const SosOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SosCubit, SosState>(
      builder: (context, state) {
        final isActive = state is SosActive;
        return Stack(
          children: [
            child,
            if (isActive)
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 12,
                child: const _SosIndicatorDot(),
              ),
          ],
        );
      },
    );
  }
}

/// A tiny pulsing dot — subtle enough not to draw attention,
/// but visible to the user so they know SOS is active.
class _SosIndicatorDot extends StatefulWidget {
  const _SosIndicatorDot();

  @override
  State<_SosIndicatorDot> createState() => _SosIndicatorDotState();
}

class _SosIndicatorDotState extends State<_SosIndicatorDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: SafMehTheme.emergencyRose,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: SafMehTheme.emergencyRose.withValues(alpha: 0.5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
