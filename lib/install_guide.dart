import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_info.dart';
import 'common_widgets.dart';
import 'localization.dart';

typedef InstallStep = ({String title, String detail, String? image});

class InstallGuidePage extends StatelessWidget {
  const InstallGuidePage({super.key});

  static List<InstallStep> steps(AppLocalizations l) => [
    (
      title: l.installStep1Title,
      detail: l.installStep1Detail,
      image: 'assets/images/install/step-1.png',
    ),
    (title: l.installStep2Title, detail: l.installStep2Detail, image: null),
    (
      title: l.installStep3Title,
      detail: l.installStep3Detail,
      image: 'assets/images/install/step-3.png',
    ),
  ];

  Future<void> _copyUrl(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: siteUrl));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.urlCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final installSteps = steps(l);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.addToHomeScreen),
        actions: const [LanguageSwitcher()],
      ),
      body: PageScroll(
        children: [
          Text(
            l.installIntro,
            style: theme.textTheme.bodyLarge?.copyWith(color: muted),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const SelectableText(siteUrl),
              trailing: IconButton(
                tooltip: l.copyUrl,
                icon: const Icon(Icons.content_copy_outlined),
                onPressed: () => _copyUrl(context),
              ),
            ),
          ),
          const SectionHeader('iPhone / iPad · Safari'),
          ResponsiveGrid(
            minItemWidth: 260,
            equalHeight: false,
            children: [
              for (var i = 0; i < installSteps.length; i++)
                _StepCard(index: i, step: installSteps[i]),
            ],
          ),
          SectionHeader(l.otherBrowsers),
          Text(
            l.otherBrowsersGuide,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: muted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.index, required this.step});

  final int index;
  final InstallStep step;

  void _showImage(BuildContext context) => showDialog<void>(
    context: context,
    builder: (ctx) => Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: ctx.l10n.close,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(ctx),
          ),
          title: Text(step.title),
        ),
        body: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: _preview(),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _preview() => switch (step.image) {
    final image? => Image.asset(
      image,
      fit: BoxFit.contain,
      semanticLabel: step.title,
    ),
    null => const _ShareMenuIllustration(),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  child: Text(
                    '${index + 1}',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              step.detail,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 260),
                child: Semantics(
                  button: true,
                  label: step.image == null
                      ? context.l10n.shareIllustration
                      : context.l10n.enlargeScreenshot(index + 1, step.title),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showImage(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _preview(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A localized diagram of the relevant share actions, without device or contact data.
class _ShareMenuIllustration extends StatelessWidget {
  const _ShareMenuIllustration();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.ios_share, size: 32),
          const SizedBox(height: 8),
          Text(l.shareMenuTitle, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 16),
          for (final action in [
            (Icons.copy_outlined, l.copyAction, false),
            (Icons.bookmark_border, l.bookmarkAction, false),
            (Icons.add_box_outlined, l.addToHomeScreen, true),
          ])
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: action.$3 ? scheme.primaryContainer : scheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(action.$1, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(action.$2)),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(
            l.shareIllustration,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
