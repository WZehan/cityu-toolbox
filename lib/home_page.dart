import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'app_info.dart';
import 'campus_tools.dart';
import 'common_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.showInstallGuide = kIsWeb});

  /// The add-to-home-screen guide only makes sense for the web build.
  final bool showInstallGuide;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _search = TextEditingController();
  int _filter = 0; // 0 = all, otherwise ToolCategory.index + 1
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 720;

    final sections = [
      for (final category in ToolCategory.values)
        if (_filter == 0 || _filter == category.index + 1)
          (
            category,
            allTools
                .where((t) => t.category == category && t.matches(_query))
                .toList(),
          ),
    ].where((s) => s.$2.isNotEmpty).toList();

    final searchBar = SearchBar(
      controller: _search,
      hintText: '搜索工具',
      leading: const Icon(Icons.search),
      trailing: [
        if (_query.isNotEmpty)
          IconButton(
            tooltip: '清除',
            icon: const Icon(Icons.close),
            onPressed: () {
              _search.clear();
              setState(() => _query = '');
            },
          ),
      ],
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHigh),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      constraints: const BoxConstraints(minHeight: 48),
      onChanged: (v) => setState(() => _query = v),
    );

    final filter = SegmentedButton<int>(
      showSelectedIcon: false,
      segments: [
        const ButtonSegment(value: 0, label: Text('全部')),
        for (final c in ToolCategory.values)
          ButtonSegment(value: c.index + 1, label: Text(c.label)),
      ],
      selected: {_filter},
      onSelectionChanged: (s) => setState(() => _filter = s.first),
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: pageGutter(width),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/toolbox.png',
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(width: 12),
            const Text(appName),
          ],
        ),
      ),
      body: PageScroll(
        children: [
          if (wide)
            Row(
              children: [
                filter,
                const Spacer(),
                SizedBox(width: 320, child: searchBar),
              ],
            )
          else ...[
            searchBar,
            const SizedBox(height: 12),
            filter,
          ],
          for (final (category, tools) in sections) ...[
            SectionHeader(category.label),
            ResponsiveGrid(
              children: [for (final t in tools) ToolCard(tool: t)],
            ),
          ],
          if (sections.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 40,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '没有找到相关工具',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.showInstallGuide) ...[
            const SectionHeader('更多'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.add_to_home_screen),
                title: const Text('添加到主屏幕'),
                subtitle: const Text('像 App 一样从桌面打开'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/install'),
              ),
            ),
          ],
          const SizedBox(height: 40),
          Text(
            '$appName · 构建版本 $appBuildVersion\n学生便民工具，非香港城市大学官方应用',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  const ToolCard({super.key, required this.tool});

  final CampusTool tool;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: InkWell(
        onTap: () => tool.open(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(tool.icon, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tool.subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    for (final info in tool.info) ...[
                      const SizedBox(height: 6),
                      InfoLine(info.icon, info.text, dense: true),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                tool.isExternal ? Icons.open_in_new : Icons.chevron_right,
                size: tool.isExternal ? 18 : 22,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
