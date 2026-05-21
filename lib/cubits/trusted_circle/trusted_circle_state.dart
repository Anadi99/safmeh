import 'package:equatable/equatable.dart';
import '../../models/trusted_contact.dart';

abstract class TrustedCircleState extends Equatable {
  const TrustedCircleState();
  @override
  List<Object?> get props => [];
}

class TrustedCircleInitial extends TrustedCircleState {
  const TrustedCircleInitial();
}

class TrustedCircleLoading extends TrustedCircleState {
  const TrustedCircleLoading();
}

class TrustedCircleLoaded extends TrustedCircleState {
  final List<TrustedContact> contacts;
  const TrustedCircleLoaded(this.contacts);
  @override
  List<Object?> get props => [contacts];
}

class TrustedCircleError extends TrustedCircleState {
  final String message;
  const TrustedCircleError(this.message);
  @override
  List<Object?> get props => [message];
}
