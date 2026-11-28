import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'app_info.dart';
import 'campus_tools.dart';
import 'common_widgets.dart';
import 'localization.dart';
import 'link_launcher.dart';

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
    final l = context.l10n;
    final scheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 720;

    final sections = [
      for (final category in ToolCategory.values)
        if (_filter == 0 || _filter == category.index + 1)
          (
            category,
            allToolsFor(l)
                .where((t) => t.category == category && t.matches(_query))
                .toList(),
          ),
    ].where((s) => s.$2.isNotEmpty).toList();

    final searchBar = SearchBar(
      controller: _search,
      hintText: l.searchTools,
      leading: const Icon(Icons.search),
      trailing: [
        if (_query.isNotEmpty)
          IconButton(
            tooltip: l.clear,
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

    final filter = _CategoryFilter(
      labels: [l.all, for (final c in ToolCategory.values) c.labelFor(l)],
      selected: _filter,
      onSelected: (value) => setState(() => _filter = value),
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
            const SizedBox(width: 8),
            Flexible(child: Text(l.appName, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: const [LanguageSwitcher()],
      ),
      body: PageScroll(
        children: [
          if (wide)
            Row(
              children: [
                Expanded(child: filter),
                const SizedBox(width: 24),
                SizedBox(width: 320, child: searchBar),
              ],
            )
          else ...[
            searchBar,
            const SizedBox(height: 12),
            filter,
          ],
          for (final (category, tools) in sections) ...[
            SectionHeader(category.labelFor(l)),
            ResponsiveGrid(
              equalHeight: false,
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
                    l.noTools,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.showInstallGuide) ...[
            SectionHeader(l.more),
            Card(
              child: ListTile(
                leading: const Icon(Icons.add_to_home_screen),
                title: Text(l.addToHomeScreen),
                subtitle: Text(l.installSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/install'),
              ),
            ),
          ],
          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              TextButton.icon(
                onPressed: () => openExternalLink(context, sourceCodeUrl),
                icon: const Icon(Icons.code, size: 18),
                label: Text(l.sourceCode),
              ),
              TextButton.icon(
                onPressed: () => openExternalLink(context, authorUrl),
                icon: const Icon(Icons.person_outline, size: 18),
                label: Text(l.aboutAuthor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.homeFooter(appBuildVersion),
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

/// Normal text layout lets segment widths follow font metric updates.
class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Material(
        color: scheme.surface,
        shape: StadiumBorder(side: BorderSide(color: scheme.outline)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < labels.length; i++)
              Semantics(
                button: true,
                selected: i == selected,
                child: Ink(
                  decoration: BoxDecoration(
                    color: i == selected ? scheme.secondaryContainer : null,
                    border: i == 0
                        ? null
                        : Border(left: BorderSide(color: scheme.outline)),
                  ),
                  child: InkWell(
                    onTap: () => onSelected(i),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          labels[i],
                          softWrap: false,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: i == selected
                                ? scheme.onSecondaryContainer
                                : scheme.onSurface,
                          ),
                        ),
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
                  mainAxisSize: MainAxisSize.min,
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
