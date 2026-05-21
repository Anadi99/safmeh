import 'dart:async';
import '../cubits/safe_walk/safe_walk_cubit.dart';
import '../cubits/safe_walk/safe_walk_state.dart';
import '../cubits/sos/sos_cubit.dart';
import '../models/sos_event.dart';
import '../services/motion_detector_service.dart';

/// Wires SafeWalkCubit with MotionDetectorService.
/// Fall detection and shake gestures from the motion sensor feed into
/// the safe walk emergency flow.
class SafeWalkCoordinator {
  final SafeWalkCubit _safeWalkCubit;
  final SosCubit _sosCubit;
  final MotionDetectorService _motionService;

  StreamSubscription<MotionEvent>? _motionSub;
  StreamSubscription<SafeWalkState>? _safeWalkSub;

  SafeWalkCoordinator({
    required SafeWalkCubit safeWalkCubit,
    required SosCubit sosCubit,
    required MotionDetectorService motionService,
  })  : _safeWalkCubit = safeWalkCubit,
        _sosCubit = sosCubit,
        _motionService = motionService;

  void start() {
    // Listen for safe walk state changes
    _safeWalkSub = _safeWalkCubit.stream.listen(_onSafeWalkStateChange);

    // Listen for motion events
    _motionSub = _motionService.motionStream.listen(_onMotionEvent);
  }

  void stop() {
    _safeWalkSub?.cancel();
    _motionSub?.cancel();
    _motionService.stopMonitoring();
  }

  void _onSafeWalkStateChange(SafeWalkState state) async {
    if (state is SafeWalkActive) {
      // Start motion monitoring when safe walk is active
      if (!_motionService.isMonitoring) {
        await _motionService.startMonitoring();
      }
    } else if (state is SafeWalkEnded || state is SafeWalkIdle) {
      // Stop motion monitoring when session ends
      await _motionService.stopMonitoring();
    } else if (state is SafeWalkEmergency) {
      // Auto-activate SOS when safe walk enters emergency state
      if (!_sosCubit.isClosed && !_sosCubit.isActive) {
        await _sosCubit.activate(SosTrigger.autoDetect);
      }
    }
  }

  void _onMotionEvent(MotionEvent event) {
    final safeWalkState = _safeWalkCubit.state;
    if (safeWalkState is! SafeWalkActive) return;

    if (event.type == MotionEventType.potentialFall) {
      // Fall detected — trigger emergency immediately
      _safeWalkCubit.triggerEmergency();
    }
  }

  void dispose() {
    stop();
  }
}
