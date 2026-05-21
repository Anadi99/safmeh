import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/comfort/comfort.dart';
import '../../models/comfort_note.dart';
import '../../theme/safmeh_theme.dart';
import '../../widgets/soft_button.dart';

class ComfortScreen extends StatefulWidget {
  const ComfortScreen({super.key});

  @override
  State<ComfortScreen> createState() => _ComfortScreenState();
}

class _ComfortScreenState extends State<ComfortScreen> {
  static const _quotes = [
    'You are stronger than you think 🌸',
    'Every step forward is progress 💕',
    'You are never truly alone.',
    'Small steps still move you forward.',
    'Be gentle with yourself today.',
    'You matter more than you know.',
  ];

  int _quoteIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ComfortCubit>().loadNotes();
    _quoteIndex = DateTime.now().second % _quotes.length;
  }

  void _showAddNoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ComfortCubit>(),
        child: const _AddNoteSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SafMehTheme.softWhite,
      appBar: AppBar(
        title: const Text('Comfort Corner 🌸'),
        backgroundColor: SafMehTheme.pureWhite,
        foregroundColor: SafMehTheme.textDark,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddNoteSheet,
        backgroundColor: SafMehTheme.blushPink,
        foregroundColor: SafMehTheme.pureWhite,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Note', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: BlocBuilder<ComfortCubit, ComfortState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Active comfort message banner
              if (state is ComfortLoaded && state.activeMessage != null)
                SliverToBoxAdapter(
                  child: _ComfortMessageBanner(
                    message: state.activeMessage!,
                    onDismiss: () => context.read<ComfortCubit>().dismissMessage(),
                  ),
                ),

              // Quote of the moment
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _QuoteCard(quote: _quotes[_quoteIndex]),
                ),
              ),

              // Notes section header
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: Text(
                    'Your notes',
                    style: TextStyle(
                      color: SafMehTheme.textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              // Notes list
              if (state is ComfortLoading)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(color: SafMehTheme.blushPink),
                    ),
                  ),
                )
              else if (state is ComfortLoaded && state.notes.isEmpty)
                const SliverToBoxAdapter(child: _EmptyNotesState())
              else if (state is ComfortLoaded)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NoteCard(note: state.notes[index]),
                      ),
                      childCount: state.notes.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ComfortMessageBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ComfortMessageBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [SafMehTheme.blushPink, SafMehTheme.deepPink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SafMehTheme.blushPink.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🌸', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            child: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final String quote;
  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SafMehTheme.palePink,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SafMehTheme.dustyRose),
      ),
      child: Row(
        children: [
          const Text('💭', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              quote,
              style: const TextStyle(
                color: SafMehTheme.textDark,
                fontSize: 15,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final ComfortNote note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: SafMehTheme.emergencyRose,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
      ),
      onDismissed: (_) => context.read<ComfortCubit>().deleteNote(note.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SafMehTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SafMehTheme.dustyRose),
          boxShadow: [
            BoxShadow(
              color: SafMehTheme.blushPink.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                color: SafMehTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            if (note.body.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                note.body,
                style: const TextStyle(color: SafMehTheme.textMuted, fontSize: 13, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyNotesState extends StatelessWidget {
  const _EmptyNotesState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Text('📝', style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Text(
            'No notes yet',
            style: TextStyle(
              color: SafMehTheme.textDark,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add comforting reminders, affirmations, or anything that makes you feel safe.',
            textAlign: TextAlign.center,
            style: TextStyle(color: SafMehTheme.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _AddNoteSheet extends StatefulWidget {
  const _AddNoteSheet();

  @override
  State<_AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<_AddNoteSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;
    context.read<ComfortCubit>().addNote(
          title: _titleController.text,
          body: _bodyController.text,
        );
    Navigator.of(context).pop();
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
            'Add a comfort note 💕',
            style: TextStyle(
              color: SafMehTheme.textDark,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Title',
              prefixIcon: Icon(Icons.title_rounded, color: SafMehTheme.blushPink),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              prefixIcon: Icon(Icons.notes_rounded, color: SafMehTheme.blushPink),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          SoftButton(
            label: 'Save Note',
            icon: Icons.favorite_rounded,
            width: double.infinity,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
