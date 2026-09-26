import 'package:flutter/material.dart';

import 'link_launcher.dart';

enum ToolCategory {
  dining('食在城大'),
  study('学在城大');

  const ToolCategory(this.label);
  final String label;
}

class ToolInfo {
  const ToolInfo(this.icon, this.text);
  final IconData icon;
  final String text;
}

class CampusTool {
  const CampusTool({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    this.info = const [],
    this.keywords = '',
    this.url,
    this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final ToolCategory category;
  final List<ToolInfo> info;

  /// Extra search terms that are not displayed (e.g. English names).
  final String keywords;
  final String? url;
  final String? route;

  bool get isExternal => route == null && url != null;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return [
      title,
      subtitle,
      keywords,
      for (final i in info) i.text,
    ].join(' ').toLowerCase().contains(q);
  }

  void open(BuildContext context) {
    if (route != null) {
      Navigator.pushNamed(context, route!);
    } else if (url != null) {
      openExternalLink(context, url!);
    }
  }
}

const diningTools = [
  CampusTool(
    title: 'AC1 城大食坊',
    subtitle: 'City Express · 线上点餐',
    icon: Icons.ramen_dining_outlined,
    category: ToolCategory.dining,
    info: [
      ToolInfo(Icons.place_outlined, '中银（香港）综合楼 5 楼'),
      ToolInfo(Icons.schedule_outlined, '周一至周日 07:30–21:00'),
    ],
    keywords: 'canteen AC1',
    url: 'https://csd.order.place/home/store/112870?mode=prekiosk',
  ),
  CampusTool(
    title: 'AC2 Canteen',
    subtitle: '7 个窗口 · 4 个支持线上点餐',
    icon: Icons.rice_bowl_outlined,
    category: ToolCategory.dining,
    info: [
      ToolInfo(Icons.place_outlined, '李达三叶耀珍学术楼 3 楼'),
      ToolInfo(Icons.schedule_outlined, '周一至周日 07:30–21:00'),
    ],
    keywords: 'canteen AC2 四季茶坊 Euro Gourmet 西北麵館 餃餃陣 麻辣滾燙 拾味 開味小店',
    route: '/ac2',
  ),
  CampusTool(
    title: 'AC3 Bistro',
    subtitle: '线上点餐',
    icon: Icons.restaurant_outlined,
    category: ToolCategory.dining,
    info: [
      ToolInfo(Icons.place_outlined, '刘鸣炜学术楼 7 楼'),
      ToolInfo(Icons.schedule_outlined, '周一至周六 07:30–21:00'),
      ToolInfo(Icons.event_busy_outlined, '周日及公众假期休息'),
    ],
    keywords: 'canteen AC3',
    url:
        'https://pth5.qmai.cn/mp-monorepo-h5/web/index.html#/pages/takefood/index?store_id=221033&multi_id=328009',
  ),
];

const studyTools = [
  CampusTool(
    title: '图书馆资源',
    subtitle: '馆藏搜索、八校通、学术数据库与往年试题',
    icon: Icons.local_library_outlined,
    category: ToolCategory.study,
    keywords: 'Library Resources exam paper',
    route: '/library',
  ),
  CampusTool(
    title: '图书馆座位预约',
    subtitle: '在线查看并预约图书馆座位',
    icon: Icons.event_seat_outlined,
    category: ToolCategory.study,
    keywords: 'Library Seat Booking',
    url: 'https://booking.cityu.edu.hk/app/booking-types',
  ),
  CampusTool(
    title: '运动中心场馆预约',
    subtitle: '预约运动中心的场地与设施',
    icon: Icons.sports_basketball_outlined,
    category: ToolCategory.study,
    keywords: 'Sports Facilities Booking',
    url: 'https://sportsbooking.cityu.edu.hk/',
  ),
  CampusTool(
    title: '在读证明预填表',
    subtitle: '整理申请资料，预览后一键复制',
    icon: Icons.description_outlined,
    category: ToolCategory.study,
    keywords: 'Student testimonial',
    route: '/testimonial',
  ),
];

const allTools = [...diningTools, ...studyTools];
