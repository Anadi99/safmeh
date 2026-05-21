import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/pretend_mode/pretend_mode_cubit.dart';
import '../../cubits/pretend_mode/pretend_mode_state.dart';
import '../../models/pretend_mode_config.dart';

class PretendModeScreen extends StatelessWidget {
  const PretendModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PretendModeCubit, PretendModeState>(
      listener: (context, state) {
        if (state is PretendModeUnlocked) {
          // Navigate to Safety Dashboard when unlocked
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      },
      builder: (context, state) {
        DecoyAppType decoyType = DecoyAppType.calculator;
        if (state is PretendModeActive) decoyType = state.decoyType;
        if (state is PretendModePinError) decoyType = state.decoyType;

        switch (decoyType) {
          case DecoyAppType.calculator:
            return const _CalculatorDecoy();
          case DecoyAppType.notes:
            return const _NotesDecoy();
          case DecoyAppType.journal:
            return const _JournalDecoy();
          case DecoyAppType.music:
            return const _MusicDecoy();
        }
      },
    );
  }
}

// ─── Calculator Decoy ────────────────────────────────────────────────────────

class _CalculatorDecoy extends StatefulWidget {
  const _CalculatorDecoy();

  @override
  State<_CalculatorDecoy> createState() => _CalculatorDecoyState();
}

class _CalculatorDecoyState extends State<_CalculatorDecoy> {
  String _display = '0';
  String _pinBuffer = '';

  void _onButton(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _pinBuffer = '';
      } else if (value == '=') {
        // Hidden PIN check — treat display as PIN input
        context.read<PretendModeCubit>().onPinInput(_pinBuffer);
      } else if (RegExp(r'[0-9]').hasMatch(value)) {
        _pinBuffer += value;
        _display = _display == '0' ? value : _display + value;
      } else {
        _display = _display + value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  _display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w200,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Buttons
            _buildCalcButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalcButtons() {
    final rows = [
      ['C', '+/-', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['0', '.', '='],
    ];
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: rows.map((row) {
          return Row(
            children: row.map((btn) {
              final isZero = btn == '0';
              final isOperator = ['÷', '×', '−', '+', '='].contains(btn);
              final isTop = ['C', '+/-', '%'].contains(btn);
              return Expanded(
                flex: isZero ? 2 : 1,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () => _onButton(btn),
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                        color: isOperator
                            ? const Color(0xFFFF9F0A)
                            : isTop
                                ? const Color(0xFFD4D4D2)
                                : const Color(0xFF333333),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          btn,
                          style: TextStyle(
                            color: isTop ? Colors.black : Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Notes Decoy ─────────────────────────────────────────────────────────────

class _NotesDecoy extends StatefulWidget {
  const _NotesDecoy();

  @override
  State<_NotesDecoy> createState() => _NotesDecoyState();
}

class _NotesDecoyState extends State<_NotesDecoy> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkPin(String value) {
    // Check if the last N characters match the PIN pattern
    // PIN is entered as text — user types it and it gets checked
    context.read<PretendModeCubit>().onPinInput(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDE7),
        elevation: 0,
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Done', style: TextStyle(color: Color(0xFFFF9F0A))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: null,
          expands: true,
          autofocus: false,
          onChanged: _checkPin,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Start typing...',
            hintStyle: TextStyle(color: Colors.black38),
            filled: false,
          ),
        ),
      ),
    );
  }
}

// ─── Journal Decoy ───────────────────────────────────────────────────────────

class _JournalDecoy extends StatefulWidget {
  const _JournalDecoy();

  @override
  State<_JournalDecoy> createState() => _JournalDecoyState();
}

class _JournalDecoyState extends State<_JournalDecoy> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${_monthName(today.month)} ${today.day}',
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: _controller,
          maxLines: null,
          expands: true,
          onChanged: (v) => context.read<PretendModeCubit>().onPinInput(v),
          style: const TextStyle(fontSize: 16, height: 1.8, color: Colors.black87),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Dear diary...',
            hintStyle: TextStyle(color: Colors.black38),
            filled: false,
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}

// ─── Music Decoy ─────────────────────────────────────────────────────────────

class _MusicDecoy extends StatefulWidget {
  const _MusicDecoy();

  @override
  State<_MusicDecoy> createState() => _MusicDecoyState();
}

class _MusicDecoyState extends State<_MusicDecoy> {
  bool _isPlaying = false;
  String _pinBuffer = '';

  void _onSkip() {
    // Hidden: tapping skip 3 times fast enters a digit
    _pinBuffer += '1';
    context.read<PretendModeCubit>().onPinInput(_pinBuffer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album art placeholder
            Container(
              width: 240,
              height: 240,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.music_note_rounded, color: Colors.white38, size: 80),
            ),
            const SizedBox(height: 32),
            const Text(
              'Unknown Track',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Unknown Artist',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 40),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: LinearProgressIndicator(
                value: 0.35,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 40),
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: () => setState(() => _isPlaying = !_isPlaying),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 36,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 40),
                  onPressed: _onSkip,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
