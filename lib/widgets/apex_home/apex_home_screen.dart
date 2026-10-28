import 'package:flutter/material.dart';

import '../date_time_widget.dart';
import '../network_widget.dart';
import 'hdmi_shortcut_row.dart';

/// Minimal Apex TV home screen.
///
/// This widget is intentionally standalone for the first iteration: it can be
/// embedded in the existing launcher shell without replacing its navigation or
/// database layer.
class ApexHomeScreen extends StatelessWidget {
  const ApexHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 32, 48, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DateTimeWidget('EEE d MMM • HH:mm'),
                  const NetworkWidget(),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Apex TV',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Votre launcher, sans distraction.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              const HdmiShortcutRow(),
              const Spacer(),
              Text(
                'Utilisez la télécommande pour naviguer.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
