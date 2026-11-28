import 'package:flutter/material.dart';

import 'link_launcher.dart';
import 'localization.dart';

enum ToolCategory {
  dining,
  study;

  String labelFor(AppLocalizations l) => switch (this) {
    dining => l.dining,
    study => l.study,
  };
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
    this.notice,
    this.keywords = '',
    this.url,
    this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final ToolCategory category;
  final List<ToolInfo> info;
  final String? notice;

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
      ?notice,
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

List<CampusTool> get diningTools => diningToolsFor(defaultStrings);

List<CampusTool> diningToolsFor(AppLocalizations l) => [
  CampusTool(
    title: l.ac1Title,
    subtitle: l.ac1Subtitle,
    icon: Icons.ramen_dining_outlined,
    category: ToolCategory.dining,
    info: [
      ToolInfo(Icons.place_outlined, l.ac1Location),
      ToolInfo(Icons.schedule_outlined, l.dailyHours),
    ],
    keywords: 'canteen AC1',
    url: 'https://csd.order.place/home/store/112870?mode=prekiosk',
  ),
  CampusTool(
    title: 'AC2 Canteen',
    subtitle: l.ac2Subtitle,
    icon: Icons.rice_bowl_outlined,
    category: ToolCategory.dining,
    info: [
      ToolInfo(Icons.place_outlined, l.ac2Location),
      ToolInfo(Icons.schedule_outlined, l.dailyHours),
    ],
    keywords: 'canteen AC2 四季茶坊 Euro Gourmet 西北麵館 餃餃陣 麻辣滾燙 拾味 開味小店',
    route: '/ac2',
  ),
  CampusTool(
    title: 'AC3 Bistro',
    subtitle: l.onlineOrdering,
    icon: Icons.restaurant_outlined,
    category: ToolCategory.dining,
    info: [
      ToolInfo(Icons.place_outlined, l.ac3Location),
      ToolInfo(Icons.schedule_outlined, l.weekdayHours),
      ToolInfo(Icons.event_busy_outlined, l.holidayClosed),
    ],
    keywords: 'canteen AC3',
    url:
        'https://pth5.qmai.cn/mp-monorepo-h5/web/index.html#/pages/takefood/index?store_id=221033&multi_id=328009',
  ),
];

List<CampusTool> get studyTools => studyToolsFor(defaultStrings);

List<CampusTool> studyToolsFor(AppLocalizations l) => [
  CampusTool(
    title: l.libraryResources,
    subtitle: l.librarySubtitle,
    icon: Icons.local_library_outlined,
    category: ToolCategory.study,
    keywords: 'Library Resources exam paper',
    route: '/library',
  ),
  CampusTool(
    title: l.publicResources,
    subtitle: l.publicResourcesSubtitle,
    icon: Icons.event_seat_outlined,
    category: ToolCategory.study,
    keywords:
        'Public Resource Booking Library Seat Booking 公共资源预约 公共資源預約 图书馆座位 圖書館座位',
    url: 'https://booking.cityu.edu.hk/app/booking-types',
  ),
  CampusTool(
    title: l.sportsBooking,
    subtitle: l.sportsSubtitle,
    icon: Icons.sports_basketball_outlined,
    category: ToolCategory.study,
    keywords: 'Sports Facilities Booking',
    url: 'https://sportsbooking.cityu.edu.hk/',
  ),
  CampusTool(
    title: l.testimonial,
    subtitle: l.testimonialSubtitle,
    icon: Icons.description_outlined,
    category: ToolCategory.study,
    keywords: 'Student testimonial',
    route: '/testimonial',
  ),
  CampusTool(
    title: l.panoramaNavigation,
    subtitle: l.panoramaNavigationSubtitle,
    icon: Icons.panorama_photosphere_outlined,
    category: ToolCategory.study,
    notice: l.panoramaNavigationDemoNotice,
    keywords: 'CityU panorama navigation 全景导航 全景導航 校园地图 校園地圖',
    url: 'https://cityu-panorama-navigation.wangzehan.com/',
  ),
];

List<CampusTool> allToolsFor(AppLocalizations l) => [
  ...diningToolsFor(l),
  ...studyToolsFor(l),
];
