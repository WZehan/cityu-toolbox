import 'package:flutter/material.dart';

import 'common_widgets.dart';
import 'link_launcher.dart';

const libraryFindBaseUrl =
    'https://julac-cuh.primo.exlibrisgroup.com/discovery/search?tab=Everything&sortby=rank&vid=852JULAC_CUH:CUH&mode=advanced&offset=0&search_scope=MyInst_and_CI&query=any,contains,';

String libraryFindSearchUrl(String keyword) =>
    '$libraryFindBaseUrl${Uri.encodeComponent(keyword.trim())}';

const _resources = [
  (
    title: '八校通申请',
    subtitle: '申请使用八所大学图书馆的馆际服务',
    icon: Icons.swap_horiz,
    url: 'https://www.cityu.edu.hk/lib/service/otherlib/application.htm',
  ),
  (
    title: '学术资源',
    subtitle: '按学科浏览图书馆电子数据库',
    icon: Icons.menu_book_outlined,
    url: 'https://app3.lib.cityu.edu.hk/ereslist/db_subject.php',
  ),
  (
    title: '往年考试试题下载',
    subtitle: '查找和下载过往考试试题',
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
    return Scaffold(
      appBar: AppBar(title: const Text('图书馆资源')),
      body: PageScroll(
        maxWidth: 760,
        children: [
          const SectionHeader('搜索馆藏', top: 8),
          SearchBar(
            controller: searchController,
            hintText: '书名、作者、主题或关键词',
            leading: const Icon(Icons.search),
            trailing: [
              IconButton(
                tooltip: '搜索',
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
          const SectionHeader('常用资源'),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < _resources.length; i++) ...[
                  if (i > 0) const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(_resources[i].icon),
                    title: Text(_resources[i].title),
                    subtitle: Text(_resources[i].subtitle),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: () => openExternalLink(context, _resources[i].url),
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
