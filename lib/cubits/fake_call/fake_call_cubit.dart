import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/fake_call_config.dart';
import 'fake_call_state.dart';

class FakeCallCubit extends Cubit<FakeCallState> {
  Timer? _scheduleTimer;

  FakeCallCubit() : super(const FakeCallIdle());

  /// Trigger an instant fake call immediately.
  void triggerInstant(FakeCallConfig config) {
    _scheduleTimer?.cancel();
    emit(FakeCallRinging(config));
  }

  /// Schedule a fake call at [scheduledAt].
  void scheduleCall(FakeCallConfig config, DateTime scheduledAt) {
    _scheduleTimer?.cancel();
    final delay = scheduledAt.difference(DateTime.now());
    if (delay.isNegative) {
      emit(FakeCallRinging(config));
      return;
    }
    _scheduleTimer = Timer(delay, () => emit(FakeCallRinging(config)));
  }

  /// User answers the fake call.
  void answerCall() {
    final current = state;
    if (current is FakeCallRinging) {
      emit(FakeCallActive(current.config));
    }
  }

  /// User ends/declines the fake call.
  void endCall() {
    _scheduleTimer?.cancel();
    emit(const FakeCallEnded());
    // Return to idle after brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (state is FakeCallEnded) emit(const FakeCallIdle());
    });
  }

  @override
  Future<void> close() {
    _scheduleTimer?.cancel();
    return super.close();
  }
}
