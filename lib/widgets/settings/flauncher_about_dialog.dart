/*
 * FLauncher
 * Copyright (C) 2024 LeanBitLab
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:apex_tv/flauncher_channel.dart';
import 'package:apex_tv/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Existing class name retained for compatibility with settings.
class LTvLauncherAboutDialog extends StatelessWidget {
  const LTvLauncherAboutDialog({super.key, required this.packageInfo});
  final PackageInfo packageInfo;

  Future<void> _open(BuildContext context, String url) async {
    final opened = await FLauncherChannel().openUrl(url);
    if (!context.mounted || opened) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(strings.aboutFlauncher),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('v${packageInfo.version} (${packageInfo.buildNumber})'),
              const SizedBox(height: 16),
              Text(strings
                  .textAboutDialog('https://github.com/Skyral1/Apex-TV')),
              const SizedBox(height: 16),
              TextButton.icon(
                autofocus: true,
                onPressed: () =>
                    _open(context, 'https://github.com/Skyral1/Apex-TV'),
                icon: const Icon(Icons.code),
                label: const Text('Apex TV — GitHub'),
              ),
              TextButton.icon(
                onPressed: () =>
                    _open(context, 'https://github.com/Skyral1/Apex-TV/issues'),
                icon: const Icon(Icons.bug_report_outlined),
                label: const Text('Apex TV — GitHub Issues'),
              ),
              TextButton.icon(
                onPressed: () => _open(
                    context, 'https://github.com/leanbitlab-org/LtvLauncher'),
                icon: const Icon(Icons.history),
                label: const Text('LTvLauncher — LeanBitLab'),
              ),
              TextButton.icon(
                onPressed: () =>
                    _open(context, 'https://gitlab.com/flauncher/flauncher'),
                icon: const Icon(Icons.history),
                label: const Text('FLauncher — Étienne Fesser'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }
}
