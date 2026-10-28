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
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Keeps the existing class name so settings callers remain compatible.
class LTvLauncherAboutDialog extends StatelessWidget {
  const LTvLauncherAboutDialog({super.key, required this.packageInfo});

  final PackageInfo packageInfo;

  Future<void> _open(BuildContext context, String url) async {
    final opened = await FLauncherChannel().openUrl(url);
    if (!context.mounted || opened) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(content: Text('Impossible d’ouvrir le lien.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Apex TV'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('v${packageInfo.version} (${packageInfo.buildNumber})'),
              const SizedBox(height: 12),
              const Text('Maintenu par Skyral1'),
              const SizedBox(height: 12),
              const Text(
                'Un lanceur open source personnalisable pour Android TV et Google TV.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Basé sur LTvLauncher de LeanBitLab et sur FLauncher d’Étienne Fesser.\nLicence GNU GPL v3 ou ultérieure.',
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                autofocus: true,
                onPressed: () => _open(context, 'https://github.com/Skyral1/Apex-TV'),
                icon: const Icon(Icons.code),
                label: const Text('Dépôt Apex TV'),
              ),
              TextButton.icon(
                onPressed: () => _open(context, 'https://github.com/Skyral1/Apex-TV/issues'),
                icon: const Icon(Icons.bug_report_outlined),
                label: const Text('Signaler un problème'),
              ),
              TextButton.icon(
                onPressed: () => _open(context, 'https://github.com/leanbitlab-org/LtvLauncher'),
                icon: const Icon(Icons.history),
                label: const Text('Projet d’origine : LTvLauncher'),
              ),
              TextButton.icon(
                onPressed: () => _open(context, 'https://github.com/Skyral1'),
                icon: const Icon(Icons.person_outline),
                label: const Text('Profil du mainteneur'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}
