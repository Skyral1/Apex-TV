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

/// Retains the existing entry point while explicitly identifying beneficiaries.
class DonateDialog extends StatelessWidget {
  const DonateDialog({super.key});

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
      title: const Text('Soutenir les projets'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apex TV est maintenu par Skyral1. Aucun lien de dons Apex TV n’est configuré dans cette version. Vous pouvez contribuer sur GitHub.',
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                autofocus: true,
                onPressed: () => _open(context, 'https://github.com/Skyral1/Apex-TV'),
                icon: const Icon(Icons.code),
                label: const Text('Contribuer à Apex TV'),
              ),
              const Divider(),
              const Text(
                'Soutenir LeanBitLab, auteur de LTvLauncher : les liens ci-dessous bénéficient au projet d’origine, et non à Skyral1.',
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _open(context, 'https://opencollective.com/leanbitlab-org'),
                child: const Text('LeanBitLab — Open Collective'),
              ),
              TextButton(
                onPressed: () => _open(context, 'https://github.com/sponsors/LeanBitLab'),
                child: const Text('LeanBitLab — GitHub Sponsors'),
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
