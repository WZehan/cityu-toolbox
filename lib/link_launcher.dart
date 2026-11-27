import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'localization.dart';

Future<void> openExternalLink(BuildContext context, String url) async {
  try {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    if (!opened) throw StateError('Unable to open URL');
  } catch (_) {
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.linkErrorTitle),
        content: SelectableText(ctx.l10n.linkErrorMessage(url)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(ctx.l10n.close),
          ),
        ],
      ),
    );
  }
}
