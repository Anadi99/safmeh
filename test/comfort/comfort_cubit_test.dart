import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/comfort/comfort.dart';

void main() {
  group('ComfortCubit', () {
    late ComfortCubit cubit;

    setUp(() {
      cubit = ComfortCubit(
        repository: MockComfortRepository(),
        userId: 'user-001',
      );
    });

    tearDown(() => cubit.close());

    test('initial state is ComfortInitial', () {
      expect(cubit.state, isA<ComfortInitial>());
    });

    test('loadNotes emits ComfortLoaded', () async {
      await cubit.loadNotes();
      expect(cubit.state, isA<ComfortLoaded>());
    });

    test('loadNotes returns empty list initially', () async {
      await cubit.loadNotes();
      expect((cubit.state as ComfortLoaded).notes, isEmpty);
    });

    test('addNote adds a note', () async {
      await cubit.loadNotes();
      await cubit.addNote(title: 'Test', body: 'Hello');
      expect((cubit.state as ComfortLoaded).notes.length, 1);
    });

    test('addNote stores correct title and body', () async {
      await cubit.loadNotes();
      await cubit.addNote(title: 'My Note', body: 'Some text');
      final note = (cubit.state as ComfortLoaded).notes.first;
      expect(note.title, 'My Note');
      expect(note.body, 'Some text');
    });

    test('deleteNote removes a note', () async {
      await cubit.loadNotes();
      await cubit.addNote(title: 'Test', body: 'Hello');
      final id = (cubit.state as ComfortLoaded).notes.first.id;
      await cubit.deleteNote(id);
      expect((cubit.state as ComfortLoaded).notes, isEmpty);
    });

    test('showComfortMessage sets activeMessage', () async {
      await cubit.loadNotes();
      cubit.showComfortMessage();
      expect((cubit.state as ComfortLoaded).activeMessage, isNotNull);
    });

    test('dismissMessage clears activeMessage', () async {
      await cubit.loadNotes();
      cubit.showComfortMessage();
      cubit.dismissMessage();
      expect((cubit.state as ComfortLoaded).activeMessage, isNull);
    });
  });
}
