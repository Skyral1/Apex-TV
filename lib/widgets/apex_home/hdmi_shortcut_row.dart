import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../flauncher_channel.dart';

/// TV-friendly shortcut tile used to open an HDMI input.
class HdmiShortcutTile extends StatefulWidget {
  const HdmiShortcutTile({
    super.key,
    required this.label,
    required this.inputId,
  });

  final String label;
  final String inputId;

  @override
  State<HdmiShortcutTile> createState() => _HdmiShortcutTileState();
}

class _HdmiShortcutTileState extends State<HdmiShortcutTile> {
  bool _focused = false;
  bool _launching = false;

  Future<void> _launch() async {
    if (_launching) return;

    setState(() => _launching = true);

    final channel = FLauncherChannel();
    final launched = await channel.launchTvInput(widget.inputId);

    if (!mounted) return;

    setState(() => _launching = false);

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d’ouvrir ${widget.label}.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          _launch();
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
          child: _launching
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(
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

/// Horizontal row of the first available Android TV inputs.
///
/// Input identifiers are provided by Android TV; they are not assumed to be
/// literally "HDMI1" or "HDMI2".
class HdmiShortcutRow extends StatefulWidget {
  const HdmiShortcutRow({super.key});

  @override
  State<HdmiShortcutRow> createState() => _HdmiShortcutRowState();
}

class _HdmiShortcutRowState extends State<HdmiShortcutRow> {
  final FLauncherChannel _channel = FLauncherChannel();
  late final Future<List<Map<dynamic, dynamic>>> _inputs;

  @override
  void initState() {
    super.initState();
    _inputs = _channel.getTvInputs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<dynamic, dynamic>>>(
      future: _inputs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final inputs = snapshot.data ?? const [];
        final visibleInputs = inputs.take(2).toList();

        if (visibleInputs.isEmpty) {
          return Text(
            'Aucune source HDMI détectée.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white54,
                ),
          );
        }

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final input in visibleInputs)
              HdmiShortcutTile(
                inputId: _inputId(input),
                label: _inputLabel(input),
              ),
          ],
        );
      },
    );
  }

  String _inputId(Map<dynamic, dynamic> input) {
    final id = input['id'] ?? input['inputId'] ?? '';
    return id.toString();
  }

  String _inputLabel(Map<dynamic, dynamic> input) {
    final label = input['label'] ??
        input['displayName'] ??
        input['name'] ??
        input['id'] ??
        'Source TV';
    return label.toString();
  }
}
