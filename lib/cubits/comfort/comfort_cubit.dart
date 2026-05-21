import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../models/comfort_note.dart';
import 'comfort_state.dart';

abstract class ComfortRepository {
  Future<List<ComfortNote>> getNotes(String userId);
  Future<ComfortNote> addNote(ComfortNote note);
  Future<void> deleteNote(String userId, String noteId);
}

class ComfortCubit extends Cubit<ComfortState> {
  final ComfortRepository _repository;
  final String userId;
  // ignore: unused_field
  final _uuid = const Uuid();

  static const List<String> _comfortMessages = [
    'Glad you reached safely 🌸',
    'Proud of you 💕',
    'You did great today.',
    'Take care of yourself.',
    'Someone is always looking out for you.',
    'You are safe now.',
    'Text someone when you arrive 💌',
    'You are doing great.',
  ];

  ComfortCubit({required ComfortRepository repository, required this.userId})
      : _repository = repository,
        super(const ComfortInitial());

  Future<void> loadNotes() async {
    emit(const ComfortLoading());
    try {
      final notes = await _repository.getNotes(userId);
      emit(ComfortLoaded(notes: notes));
    } catch (_) {
      emit(const ComfortError('Failed to load notes.'));
    }
  }

  Future<void> addNote({required String title, required String body}) async {
    final current = state is ComfortLoaded
        ? (state as ComfortLoaded).notes
        : <ComfortNote>[];
    try {
      final note = ComfortNote(
        id: '',
        userId: userId,
        title: title.trim(),
        body: body.trim(),
        createdAt: DateTime.now(),
      );
      final saved = await _repository.addNote(note);
      emit(ComfortLoaded(notes: [...current, saved]));
    } catch (_) {
      emit(const ComfortError('Failed to save note.'));
    }
  }

  Future<void> deleteNote(String noteId) async {
    final current = state is ComfortLoaded
        ? (state as ComfortLoaded).notes
        : <ComfortNote>[];
    try {
      await _repository.deleteNote(userId, noteId);
      emit(ComfortLoaded(
        notes: current.where((n) => n.id != noteId).toList(),
      ));
    } catch (_) {
      emit(const ComfortError('Failed to delete note.'));
    }
  }

  /// Show a comfort message (called on session end or arrival).
  void showComfortMessage() {
    final current = state is ComfortLoaded
        ? (state as ComfortLoaded).notes
        : <ComfortNote>[];
    final index = DateTime.now().millisecondsSinceEpoch % _comfortMessages.length;
    emit(ComfortLoaded(
      notes: current,
      activeMessage: _comfortMessages[index],
    ));
  }

  void dismissMessage() {
    final current = state is ComfortLoaded
        ? (state as ComfortLoaded).notes
        : <ComfortNote>[];
    emit(ComfortLoaded(notes: current));
  }
}
