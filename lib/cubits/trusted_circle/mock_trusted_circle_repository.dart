import 'package:uuid/uuid.dart';
import '../../models/trusted_contact.dart';
import 'trusted_circle_cubit.dart';

class MockTrustedCircleRepository implements TrustedCircleRepository {
  final Map<String, List<TrustedContact>> _store = {};
  final _uuid = const Uuid();

  @override
  Future<List<TrustedContact>> getContacts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_store[userId] ?? []);
  }

  @override
  Future<TrustedContact> addContact(TrustedContact contact) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final saved = contact.copyWith(id: _uuid.v4());
    _store.putIfAbsent(contact.userId, () => []).add(saved);
    return saved;
  }

  @override
  Future<void> updateContact(TrustedContact contact) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final list = _store[contact.userId];
    if (list != null) {
      final idx = list.indexWhere((c) => c.id == contact.id);
      if (idx != -1) list[idx] = contact;
    }
  }

  @override
  Future<void> removeContact(String userId, String contactId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _store[userId]?.removeWhere((c) => c.id == contactId);
  }
}
