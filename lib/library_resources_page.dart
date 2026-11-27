import 'package:flutter/material.dart';

import 'common_widgets.dart';
import 'link_launcher.dart';
import 'localization.dart';

const libraryFindBaseUrl =
    'https://julac-cuh.primo.exlibrisgroup.com/discovery/search?tab=Everything&sortby=rank&vid=852JULAC_CUH:CUH&mode=advanced&offset=0&search_scope=MyInst_and_CI&query=any,contains,';

String libraryFindSearchUrl(String keyword) =>
    '$libraryFindBaseUrl${Uri.encodeComponent(keyword.trim())}';

List<({String title, String subtitle, IconData icon, String url})> _resources(
  AppLocalizations l,
) => [
  (
    title: l.julacTitle,
    subtitle: l.julacSubtitle,
    icon: Icons.swap_horiz,
    url: 'https://www.cityu.edu.hk/lib/service/otherlib/application.htm',
  ),
  (
    title: l.academicResources,
    subtitle: l.academicSubtitle,
    icon: Icons.menu_book_outlined,
    url: 'https://app3.lib.cityu.edu.hk/ereslist/db_subject.php',
  ),
  (
    title: l.pastPapers,
    subtitle: l.pastPapersSubtitle,
    icon: Icons.assignment_outlined,
    url: 'https://www.cityu.edu.hk/lib/digital/exampaper/index.htm',
  ),
];

class LibraryResourcesPage extends StatefulWidget {
  const LibraryResourcesPage({super.key});

  @override
  State<LibraryResourcesPage> createState() => _LibraryResourcesPageState();
}

class _LibraryResourcesPageState extends State<LibraryResourcesPage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> searchLibrary() async {
    final keyword = searchController.text.trim();
    if (keyword.isEmpty) return;
    await openExternalLink(context, libraryFindSearchUrl(keyword));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    final resources = _resources(l);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.libraryResources),
        actions: const [LanguageSwitcher()],
      ),
      body: PageScroll(
        maxWidth: 760,
        children: [
          SectionHeader(l.searchCatalogue, top: 8),
          SearchBar(
            controller: searchController,
            hintText: l.catalogueHint,
            leading: const Icon(Icons.search),
            trailing: [
              IconButton(
                tooltip: l.search,
                icon: const Icon(Icons.arrow_forward),
                onPressed: searchLibrary,
              ),
            ],
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => searchLibrary(),
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(
              scheme.surfaceContainerHigh,
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.only(left: 16, right: 4),
            ),
            constraints: const BoxConstraints(minHeight: 52),
          ),
          SectionHeader(l.commonResources),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < resources.length; i++) ...[
                  if (i > 0) const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(resources[i].icon),
                    title: Text(resources[i].title),
                    subtitle: Text(resources[i].subtitle),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: () => openExternalLink(context, resources[i].url),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
