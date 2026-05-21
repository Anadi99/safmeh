import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/trusted_contact.dart';
import 'trusted_circle_state.dart';

abstract class TrustedCircleRepository {
  Future<List<TrustedContact>> getContacts(String userId);
  Future<TrustedContact> addContact(TrustedContact contact);
  Future<void> updateContact(TrustedContact contact);
  Future<void> removeContact(String userId, String contactId);
}

class TrustedCircleCubit extends Cubit<TrustedCircleState> {
  final TrustedCircleRepository _repository;
  final String userId;

  TrustedCircleCubit(this._repository, {required this.userId})
      : super(const TrustedCircleInitial());

  Future<void> loadContacts() async {
    emit(const TrustedCircleLoading());
    try {
      final contacts = await _repository.getContacts(userId);
      emit(TrustedCircleLoaded(contacts));
    } catch (_) {
      emit(const TrustedCircleError('Failed to load contacts.'));
    }
  }

  Future<void> addContact({
    required String name,
    required String phoneNumber,
    String? email,
    bool isEmergencyContact = false,
  }) async {
    final current = state is TrustedCircleLoaded
        ? (state as TrustedCircleLoaded).contacts
        : <TrustedContact>[];
    try {
      final contact = TrustedContact(
        id: '',
        userId: userId,
        name: name.trim(),
        phoneNumber: phoneNumber.trim(),
        email: email?.trim(),
        isEmergencyContact: isEmergencyContact,
        addedAt: DateTime.now(),
      );
      final saved = await _repository.addContact(contact);
      emit(TrustedCircleLoaded([...current, saved]));
    } catch (_) {
      emit(const TrustedCircleError('Failed to add contact.'));
    }
  }

  Future<void> removeContact(String contactId) async {
    final current = state is TrustedCircleLoaded
        ? (state as TrustedCircleLoaded).contacts
        : <TrustedContact>[];
    try {
      await _repository.removeContact(userId, contactId);
      emit(TrustedCircleLoaded(
        current.where((c) => c.id != contactId).toList(),
      ));
    } catch (_) {
      emit(const TrustedCircleError('Failed to remove contact.'));
    }
  }

  Future<void> toggleEmergencyContact(String contactId) async {
    final current = state is TrustedCircleLoaded
        ? (state as TrustedCircleLoaded).contacts
        : <TrustedContact>[];
    final contact = current.firstWhere((c) => c.id == contactId);
    final updated =
        contact.copyWith(isEmergencyContact: !contact.isEmergencyContact);
    try {
      await _repository.updateContact(updated);
      emit(TrustedCircleLoaded(
        current.map((c) => c.id == contactId ? updated : c).toList(),
      ));
    } catch (_) {
      emit(const TrustedCircleError('Failed to update contact.'));
    }
  }

  List<TrustedContact> get emergencyContacts {
    if (state is TrustedCircleLoaded) {
      return (state as TrustedCircleLoaded)
          .contacts
          .where((c) => c.isEmergencyContact)
          .toList();
    }
    return [];
  }

  List<TrustedContact> get allContacts {
    if (state is TrustedCircleLoaded) {
      return (state as TrustedCircleLoaded).contacts;
    }
    return [];
  }
}
