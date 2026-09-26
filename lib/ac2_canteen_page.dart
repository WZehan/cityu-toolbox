import 'package:flutter/material.dart';

import 'common_widgets.dart';
import 'link_launcher.dart';

const _onlineStalls = <_Ac2Stall>[
  _Ac2Stall(
    name: '四季茶坊',
    english: 'Tea House',
    logo: 'assets/images/ac2/tea_house_transparent.png',
    orderUrl: 'https://csd.order.place/home/store/612882',
  ),
  _Ac2Stall(
    name: 'Euro Gourmet',
    english: 'AC2 CANTEEN',
    logo: 'assets/images/ac2/euro_gourmet_transparent.png',
    orderUrl: 'https://csd.order.place/home/store/712882?_aigens_source=scan',
  ),
  _Ac2Stall(
    name: '西北麵館',
    english: 'XiBei Mian Guan',
    logo: 'assets/images/ac2/xibei_noodle_transparent.png',
    orderUrl:
        'https://csd.order.place/home/store/312882?_aigens_source=scan&catMode=false&mode=dinein',
  ),
  _Ac2Stall(
    name: '餃餃陣',
    english: 'Dumpling City Express',
    logo: 'assets/images/ac2/dumpling_city_express_transparent.png',
    orderUrl: 'https://csd.order.place/home/store/212882?_aigens_source=scan',
  ),
];

const _offlineStalls = <_Ac2Stall>[
  _Ac2Stall(
    name: '麻辣滾燙',
    logo: 'assets/images/ac2/mala_rolling_transparent.png',
    steps: ['挑选菜 Select Food', '按重量付款 Pay by Weight', '叫号取餐 Food Pick-up'],
  ),
  _Ac2Stall(
    name: '拾味',
    english: 'The Pick',
    logo: 'assets/images/ac2/the_pick_transparent.png',
    steps: ['排队 Queue Up', '选菜 Select Food', '付款 Settle the Bill'],
  ),
  _Ac2Stall(
    name: '開味小店',
    english: 'Tasty Corner',
    logo: 'assets/images/ac2/kai_wei_shop_transparent.png',
    steps: ['点餐 Place Order', '付款 Settle the Bill', '取餐 Food Pick-up'],
  ),
];

class Ac2CanteenPage extends StatelessWidget {
  const Ac2CanteenPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('AC2 Canteen')),
    body: PageScroll(
      children: [
        const InfoLine(Icons.place_outlined, '李达三叶耀珍学术楼 3 楼'),
        const SizedBox(height: 8),
        const InfoLine(Icons.schedule_outlined, '周一至周日 07:30–21:00'),
        const SectionHeader('线上点餐'),
        ResponsiveGrid(
          minItemWidth: 160,
          maxColumns: 4,
          children: [for (final s in _onlineStalls) _StallCard(stall: s)],
        ),
        const SectionHeader('现场点餐'),
        ResponsiveGrid(
          minItemWidth: 160,
          maxColumns: 4,
          children: [for (final s in _offlineStalls) _StallCard(stall: s)],
        ),
      ],
    ),
  );
}

class _StallCard extends StatelessWidget {
  const _StallCard({required this.stall});

  final _Ac2Stall stall;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logos are dark artwork on transparent backgrounds, so keep them on
          // a white plate in both light and dark themes.
          Container(
            height: 88,
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              stall.logo,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.storefront_outlined, color: Colors.black45),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stall.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (stall.english case final english?)
                  Text(
                    english,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: switch (stall.orderUrl) {
              final url? => FilledButton.tonal(
                onPressed: () => openExternalLink(context, url),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.open_in_new, size: 18),
                    SizedBox(width: 8),
                    Text('去点餐'),
                  ],
                ),
              ),
              null => _Steps(stall.steps),
            },
          ),
        ],
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  const _Steps(this.steps);

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(steps[i], style: theme.textTheme.bodySmall),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Ac2Stall {
  const _Ac2Stall({
    required this.name,
    required this.logo,
    this.english,
    this.orderUrl,
    this.steps = const [],
  });

  final String name;
  final String? english;
  final String logo;
  final String? orderUrl;
  final List<String> steps;
}
