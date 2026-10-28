import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// TV-friendly shortcut tile used to open an HDMI input.
class HdmiShortcutTile extends StatefulWidget {
  const HdmiShortcutTile({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  State<HdmiShortcutTile> createState() => _HdmiShortcutTileState();
}

class _HdmiShortcutTileState extends State<HdmiShortcutTile> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          widget.onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        width: 220,
        height: 120,
        decoration: BoxDecoration(
          color: _focused ? const Color(0xFF1E2A38) : const Color(0xFF141A22),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _focused ? const Color(0xFF4FC3F7) : Colors.white12,
            width: _focused ? 2.5 : 1,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: const Color(0xFF4FC3F7).withValues(alpha: 0.28),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(18),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal row of HDMI source shortcuts.
///
/// The launch callbacks are intentionally injected by the caller so this UI
/// component stays independent from Android platform channels.
class HdmiShortcutRow extends StatelessWidget {
  const HdmiShortcutRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        HdmiShortcutTile(
          label: 'HDMI 1',
          onPressed: () => _openHdmiInput(context, 'HDMI1'),
        ),
        HdmiShortcutTile(
          label: 'HDMI 2',
          onPressed: () => _openHdmiInput(context, 'HDMI2'),
        ),
      ],
    );
  }

  void _openHdmiInput(BuildContext context, String inputId) {
    // Platform-specific input launching will be connected through the existing
    // launcher channel in a later integration commit.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ouverture de $inputId à connecter.')),
    );
  }
}
