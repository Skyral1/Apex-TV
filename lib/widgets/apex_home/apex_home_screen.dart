import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apex_tv/apex_nav_trace.dart';
import 'package:apex_tv/l10n/app_localizations.dart';
import '../date_time_widget.dart';
import '../network_widget.dart';
import 'hdmi_shortcut_row.dart';

/// Full-screen preview; never replaces the existing launcher route.
class ApexHomeScreen extends StatelessWidget {
  const ApexHomeScreen({super.key});

  static String previewLabel(BuildContext context) {
    const labels = {
      'ar': 'معاينة Apex Home',
      'de': 'Apex Home Vorschau',
      'en': 'Apex Home preview',
      'es': 'Vista previa de Apex Home',
      'fr': 'Aperçu Apex Home',
      'hi': 'Apex Home पूर्वावलोकन',
      'it': 'Anteprima Apex Home',
      'ja': 'Apex Home プレビュー',
      'ko': 'Apex Home 미리보기',
      'pt': 'Pré-visualização do Apex Home',
      'ru': 'Предпросмотр Apex Home',
      'sl': 'Predogled Apex Home',
      'tr': 'Apex Home önizlemesi',
      'uk': 'Попередній перегляд Apex Home',
      'zh': 'Apex Home 预览',
    };
    return labels[Localizations.localeOf(context).languageCode] ?? labels['en']!;
  }

  @override
  Widget build(BuildContext context) {
    ApexNavTrace.install();
    void close(String source) {
      ApexNavTrace.write('preview.close source=$source', context: context);
      Navigator.of(context).pop();
      ApexNavTrace.write('preview.pop.requested source=$source');
    }
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () => close('escape'),
        const SingleActivator(LogicalKeyboardKey.goBack): () => close('goBack'),
        const SingleActivator(LogicalKeyboardKey.gameButtonB): () => close('gameButtonB'),
      },
      child: Scaffold(
        key: const Key('apexHomePreview'),
        backgroundColor: const Color(0xFF0B0F14),
        body: SafeArea(
          child: FocusTraversalGroup(
            policy: ReadingOrderTraversalPolicy(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        key: const Key('apexHomeBack'),
                        autofocus: true,
                        onPressed: () => close('button'),
                        icon: const Icon(Icons.arrow_back),
                        label: Text(MaterialLocalizations.of(context).backButtonTooltip),
                      ),
                      const Spacer(),
                      const DateTimeWidget('EEE d MMM • HH:mm', animate: false),
                      const SizedBox(width: 20),
                      const NetworkWidget(),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text('Apex TV', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(previewLabel(context)),
                  const SizedBox(height: 32),
                  Text(AppLocalizations.of(context)!.inputSources, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  const HdmiShortcutRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
