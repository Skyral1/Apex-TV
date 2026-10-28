import 'package:apex_tv/l10n/app_localizations.dart';
import 'package:apex_tv/models/tv_input.dart';
import 'package:apex_tv/providers/tv_inputs_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Uses the existing shared service and shows only valid HDMI inputs.
class HdmiShortcutRow extends StatelessWidget {
  const HdmiShortcutRow({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<TvInputsService>();
    if (!service.initialized) {
      return Text(AppLocalizations.of(context)!.loading);
    }
    final seen = <String>{};
    final inputs = service.inputs.where((input) =>
        input.type == TvInputType.hdmi &&
        input.id.trim().isNotEmpty && seen.add(input.id)).toList();
    if (inputs.isEmpty) {
      return const Text('HDMI — 0', key: Key('apexHomeNoHdmi'));
    }
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        for (final input in inputs)
          HdmiShortcutTile(key: ValueKey(input.id), input: input),
      ],
    );
  }
}

class HdmiShortcutTile extends StatefulWidget {
  const HdmiShortcutTile({super.key, required this.input});
  final TvInput input;

  @override
  State<HdmiShortcutTile> createState() => _HdmiShortcutTileState();
}

class _HdmiShortcutTileState extends State<HdmiShortcutTile> {
  bool _launching = false;
  bool _focused = false;

  Future<void> _launch() async {
    if (_launching) return;
    final service = context.read<TvInputsService>();
    setState(() => _launching = true);
    bool success;
    try {
      success = await service.switchInput(widget.input.id);
    } catch (_) {
      success = false;
    }
    if (!mounted) return;
    setState(() => _launching = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(children: [
          const Icon(Icons.error_outline),
          const SizedBox(width: 12),
          Expanded(child: Text(widget.input.label.isEmpty ? 'HDMI' : widget.input.label)),
        ])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: 220,
      height: 120,
      child: OutlinedButton(
        onPressed: _launch,
        onFocusChange: (focused) => setState(() => _focused = focused),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _focused ? const Color(0xFF1E2A38) : const Color(0xFF141A22),
          side: BorderSide(color: _focused ? accent : Colors.white24, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _launching
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(widget.input.label.isEmpty ? 'HDMI' : widget.input.label, textAlign: TextAlign.center),
      ),
    );
  }
}
