import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/trusted_circle/trusted_circle.dart';

void main() {
  group('TrustedCircleCubit', () {
    late TrustedCircleCubit cubit;

    setUp(() {
      cubit = TrustedCircleCubit(
        MockTrustedCircleRepository(),
        userId: 'user-001',
      );
    });

    tearDown(() => cubit.close());

    test('initial state is TrustedCircleInitial', () {
      expect(cubit.state, isA<TrustedCircleInitial>());
    });

    test('loadContacts emits TrustedCircleLoaded with empty list', () async {
      await cubit.loadContacts();
      expect(cubit.state, isA<TrustedCircleLoaded>());
      expect((cubit.state as TrustedCircleLoaded).contacts, isEmpty);
    });

    test('addContact adds a contact', () async {
      await cubit.loadContacts();
      await cubit.addContact(name: 'Mum', phoneNumber: '+1234567890');
      final state = cubit.state as TrustedCircleLoaded;
      expect(state.contacts.length, 1);
      expect(state.contacts.first.name, 'Mum');
    });

    test('removeContact removes a contact', () async {
      await cubit.loadContacts();
      await cubit.addContact(name: 'Mum', phoneNumber: '+1234567890');
      final id = (cubit.state as TrustedCircleLoaded).contacts.first.id;
      await cubit.removeContact(id);
      expect((cubit.state as TrustedCircleLoaded).contacts, isEmpty);
    });

    test('toggleEmergencyContact flips the flag', () async {
      await cubit.loadContacts();
      await cubit.addContact(name: 'Mum', phoneNumber: '+1234567890');
      final id = (cubit.state as TrustedCircleLoaded).contacts.first.id;
      await cubit.toggleEmergencyContact(id);
      final contact = (cubit.state as TrustedCircleLoaded).contacts.first;
      expect(contact.isEmergencyContact, isTrue);
    });

    test('emergencyContacts returns only emergency contacts', () async {
      await cubit.loadContacts();
      await cubit.addContact(
          name: 'Mum',
          phoneNumber: '+1234567890',
          isEmergencyContact: true);
      await cubit.addContact(name: 'Friend', phoneNumber: '+0987654321');
      expect(cubit.emergencyContacts.length, 1);
      expect(cubit.emergencyContacts.first.name, 'Mum');
    });
  });
}
