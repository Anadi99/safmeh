import 'package:equatable/equatable.dart';
import '../../models/fake_call_config.dart';

abstract class FakeCallState extends Equatable {
  const FakeCallState();
  @override
  List<Object?> get props => [];
}

class FakeCallIdle extends FakeCallState {
  const FakeCallIdle();
}

class FakeCallRinging extends FakeCallState {
  final FakeCallConfig config;
  const FakeCallRinging(this.config);
  @override
  List<Object?> get props => [config];
}

class FakeCallActive extends FakeCallState {
  final FakeCallConfig config;
  const FakeCallActive(this.config);
  @override
  List<Object?> get props => [config];
}

class FakeCallEnded extends FakeCallState {
  const FakeCallEnded();
}
