import 'package:flutter/material.dart';
import 'link_launcher.dart';

const libraryFindBaseUrl =
    'https://julac-cuh.primo.exlibrisgroup.com/discovery/search?tab=Everything&sortby=rank&vid=852JULAC_CUH:CUH&mode=advanced&offset=0&search_scope=MyInst_and_CI&query=any,contains,';

String libraryFindSearchUrl(String keyword) =>
    '$libraryFindBaseUrl${Uri.encodeComponent(keyword.trim())}';

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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('图书馆资源')),
    body: SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          return SingleChildScrollView(
            padding: EdgeInsets.all(wide ? 32 : 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '搜索馆藏',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (wide)
                      Row(
                        children: [
                          Expanded(child: _searchField()),
                          const SizedBox(width: 10),
                          _searchButton(width: 132),
                        ],
                      )
                    else ...[
                      _searchField(),
                      const SizedBox(height: 10),
                      _searchButton(width: double.infinity),
                    ],
                    const SizedBox(height: 28),
                    const Text(
                      '常用图书馆资源',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _LibraryResourceCard(
                      title: '八校通申请',
                      subtitle: '申请使用八所大学图书馆的馆际服务',
                      icon: Icons.swap_horiz_rounded,
                      url:
                          'https://www.cityu.edu.hk/lib/service/otherlib/application.htm',
                    ),
                    const _LibraryResourceCard(
                      title: '学术资源',
                      subtitle: '按学科浏览图书馆电子数据库',
                      icon: Icons.menu_book_rounded,
                      url:
                          'https://app3.lib.cityu.edu.hk/ereslist/db_subject.php',
                    ),
                    const _LibraryResourceCard(
                      title: '往年考试试题下载',
                      subtitle: '查找和下载过往考试试题',
                      icon: Icons.assignment_outlined,
                      url:
                          'https://www.cityu.edu.hk/lib/digital/exampaper/index.htm',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );

  Widget _searchField() => TextField(
    controller: searchController,
    textInputAction: TextInputAction.search,
    onSubmitted: (_) => searchLibrary(),
    decoration: const InputDecoration(
      hintText: '输入书名、作者、主题或关键词',
      prefixIcon: Icon(Icons.search_rounded),
    ),
  );

  Widget _searchButton({required double width}) => FilledButton.icon(
    onPressed: searchLibrary,
    icon: const Icon(Icons.search_rounded),
    label: const Text('搜索馆藏'),
    style: FilledButton.styleFrom(
      minimumSize: Size(width, 52),
      backgroundColor: const Color(0xFFC71555),
    ),
  );
}

class _LibraryResourceCard extends StatelessWidget {
  const _LibraryResourceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.url,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: Color(0xFFE6E8EE)),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFC71555).withValues(alpha: .09),
          borderRadius: BorderRadius.circular(11),
        ),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: const Color(0xFFC71555)),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(subtitle, style: const TextStyle(color: Color(0xFF737989))),
      ),
      trailing: const Icon(Icons.open_in_new_rounded, size: 19),
      onTap: () => openExternalLink(context, url),
    ),
  );
}
