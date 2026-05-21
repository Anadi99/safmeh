import 'package:uuid/uuid.dart';
import '../../models/comfort_note.dart';
import 'comfort_cubit.dart';

class MockComfortRepository implements ComfortRepository {
  final Map<String, List<ComfortNote>> _store = {};
  final _uuid = const Uuid();

  @override
  Future<List<ComfortNote>> getNotes(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_store[userId] ?? []);
  }

  @override
  Future<ComfortNote> addNote(ComfortNote note) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final saved = ComfortNote(
      id: _uuid.v4(),
      userId: note.userId,
      title: note.title,
      body: note.body,
      createdAt: note.createdAt,
    );
    _store.putIfAbsent(note.userId, () => []).add(saved);
    return saved;
  }

  @override
  Future<void> deleteNote(String userId, String noteId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _store[userId]?.removeWhere((n) => n.id == noteId);
  }
}
