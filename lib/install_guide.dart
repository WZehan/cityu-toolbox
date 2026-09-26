import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_info.dart';
import 'common_widgets.dart';

typedef InstallStep = ({String title, String detail, String image});

class InstallGuidePage extends StatelessWidget {
  const InstallGuidePage({super.key});

  static const List<InstallStep> steps = [
    (
      title: '打开网站，点击分享',
      detail: '使用 Safari 打开城大百宝箱，点击浏览器下方的分享按钮。',
      image: 'assets/images/install/step-1.png',
    ),
    (
      title: '选择「添加到主屏幕」',
      detail: '在分享菜单中向下滑动，找到并点击「添加到主屏幕」。',
      image: 'assets/images/install/step-2.png',
    ),
    (
      title: '确认名称，点击「添加」',
      detail: '确认名称后点击右上角「添加」，之后即可从桌面图标直接打开。',
      image: 'assets/images/install/step-3.png',
    ),
  ];

  Future<void> _copyUrl(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: siteUrl));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已复制网址')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: const Text('添加到主屏幕')),
      body: PageScroll(
        children: [
          Text(
            '在手机浏览器中打开以下网址，添加到主屏幕后即可从桌面直接打开。',
            style: theme.textTheme.bodyLarge?.copyWith(color: muted),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: const SelectableText(siteUrl),
              trailing: IconButton(
                tooltip: '复制网址',
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
              for (var i = 0; i < steps.length; i++)
                _StepCard(index: i, step: steps[i]),
            ],
          ),
          const SectionHeader('其他浏览器'),
          Text(
            '在浏览器的分享或菜单中查找「添加到主屏幕」或「添加到桌面」，按提示确认即可。不同浏览器的选项名称和位置可能略有不同。',
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
            tooltip: '关闭',
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(ctx),
          ),
          title: Text(step.title),
        ),
        body: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: Center(child: Image.asset(step.image, fit: BoxFit.contain)),
        ),
      ),
    ),
  );

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
                  child: Text('${index + 1}', style: theme.textTheme.labelLarge),
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
                  label: '放大第 ${index + 1} 步截图：${step.title}',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showImage(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(step.image, semanticLabel: step.title),
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
