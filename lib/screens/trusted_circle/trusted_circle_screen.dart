import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/trusted_circle/trusted_circle.dart';
import '../../models/trusted_contact.dart';
import '../../theme/safmeh_theme.dart';
import '../../widgets/soft_button.dart';

class TrustedCircleScreen extends StatefulWidget {
  const TrustedCircleScreen({super.key});

  @override
  State<TrustedCircleScreen> createState() => _TrustedCircleScreenState();
}

class _TrustedCircleScreenState extends State<TrustedCircleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TrustedCircleCubit>().loadContacts();
  }

  void _showAddContactSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TrustedCircleCubit>(),
        child: const _AddContactSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SafMehTheme.softWhite,
      appBar: AppBar(
        title: const Text('My Circle 💕'),
        backgroundColor: SafMehTheme.pureWhite,
        foregroundColor: SafMehTheme.textDark,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddContactSheet,
        backgroundColor: SafMehTheme.blushPink,
        foregroundColor: SafMehTheme.pureWhite,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 4,
      ),
      body: BlocConsumer<TrustedCircleCubit, TrustedCircleState>(
        listener: (context, state) {
          if (state is TrustedCircleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: SafMehTheme.emergencyRose,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TrustedCircleLoading) {
            return const Center(
              child: CircularProgressIndicator(color: SafMehTheme.blushPink),
            );
          }
          if (state is TrustedCircleLoaded) {
            if (state.contacts.isEmpty) {
              return _EmptyState(onAdd: _showAddContactSheet);
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemCount: state.contacts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return _ContactCard(contact: contact);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final TrustedContact contact;
  const _ContactCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(contact.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: SafMehTheme.emergencyRose,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        context.read<TrustedCircleCubit>().removeContact(contact.id);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SafMehTheme.pureWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: SafMehTheme.dustyRose, width: 1),
          boxShadow: [
            BoxShadow(
              color: SafMehTheme.blushPink.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: SafMehTheme.palePink,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  contact.name.isNotEmpty
                      ? contact.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: SafMehTheme.deepPink,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          color: SafMehTheme.textDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (contact.isEmergencyContact) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: SafMehTheme.emergencyRose,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Emergency',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.phoneNumber,
                    style: const TextStyle(
                        color: SafMehTheme.textMuted, fontSize: 13),
                  ),
                  if (contact.email != null && contact.email!.isNotEmpty)
                    Text(
                      contact.email!,
                      style: const TextStyle(
                          color: SafMehTheme.textMuted, fontSize: 12),
                    ),
                ],
              ),
            ),
            // Emergency toggle
            GestureDetector(
              onTap: () => context
                  .read<TrustedCircleCubit>()
                  .toggleEmergencyContact(contact.id),
              child: Icon(
                contact.isEmergencyContact
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: contact.isEmergencyContact
                    ? SafMehTheme.deepPink
                    : SafMehTheme.textMuted,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: SafMehTheme.palePink,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people_outline_rounded,
                  color: SafMehTheme.blushPink, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your circle is empty',
              style: TextStyle(
                color: SafMehTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add trusted people who will be notified in an emergency.',
              textAlign: TextAlign.center,
              style: TextStyle(color: SafMehTheme.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 28),
            SoftButton(
              label: 'Add someone',
              icon: Icons.person_add_rounded,
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddContactSheet extends StatefulWidget {
  const _AddContactSheet();

  @override
  State<_AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<_AddContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEmergency = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<TrustedCircleCubit>().addContact(
            name: _nameController.text,
            phoneNumber: _phoneController.text,
            email: _emailController.text.trim().isEmpty
                ? null
                : _emailController.text,
            isEmergencyContact: _isEmergency,
          );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: SafMehTheme.pureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: SafMehTheme.dustyRose,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add to your circle',
              style: TextStyle(
                color: SafMehTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline_rounded,
                    color: SafMehTheme.blushPink),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                prefixIcon:
                    Icon(Icons.phone_outlined, color: SafMehTheme.blushPink),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Phone number is required.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email (optional)',
                prefixIcon: Icon(Icons.mail_outline_rounded,
                    color: SafMehTheme.blushPink),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Switch(
                  value: _isEmergency,
                  onChanged: (v) => setState(() => _isEmergency = v),
                  activeThumbColor: SafMehTheme.deepPink,
                  activeTrackColor: SafMehTheme.blushPink,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Mark as emergency contact',
                  style: TextStyle(
                      color: SafMehTheme.textDark,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SoftButton(
              label: 'Add to circle',
              icon: Icons.favorite_rounded,
              width: double.infinity,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
