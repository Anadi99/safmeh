import 'package:equatable/equatable.dart';
import '../../models/comfort_note.dart';

abstract class ComfortState extends Equatable {
  const ComfortState();
  @override
  List<Object?> get props => [];
}

class ComfortInitial extends ComfortState {
  const ComfortInitial();
}

class ComfortLoading extends ComfortState {
  const ComfortLoading();
}

class ComfortLoaded extends ComfortState {
  final List<ComfortNote> notes;
  final String? activeMessage;
  const ComfortLoaded({required this.notes, this.activeMessage});
  @override
  List<Object?> get props => [notes, activeMessage];
}

class ComfortError extends ComfortState {
  final String message;
  const ComfortError(this.message);
  @override
  List<Object?> get props => [message];
}
