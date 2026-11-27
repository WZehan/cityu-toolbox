import 'package:flutter/material.dart';

import 'common_widgets.dart';
import 'link_launcher.dart';
import 'localization.dart';

List<_Ac2Stall> _onlineStalls(AppLocalizations l) => [
  _Ac2Stall(
    name: l.teaHouse,
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
    name: l.xibei,
    english: 'XiBei Mian Guan',
    logo: 'assets/images/ac2/xibei_noodle_transparent.png',
    orderUrl:
        'https://csd.order.place/home/store/312882?_aigens_source=scan&catMode=false&mode=dinein',
  ),
  _Ac2Stall(
    name: l.dumplingCity,
    english: 'Dumpling City Express',
    logo: 'assets/images/ac2/dumpling_city_express_transparent.png',
    orderUrl: 'https://csd.order.place/home/store/212882?_aigens_source=scan',
  ),
];

List<_Ac2Stall> _offlineStalls(AppLocalizations l) => [
  _Ac2Stall(
    name: l.malaRolling,
    logo: 'assets/images/ac2/mala_rolling_transparent.png',
    steps: [l.selectFood, l.payByWeight, l.pickUp],
  ),
  _Ac2Stall(
    name: l.thePick,
    english: 'The Pick',
    logo: 'assets/images/ac2/the_pick_transparent.png',
    steps: [l.queueUp, l.chooseFood, l.settleBill],
  ),
  _Ac2Stall(
    name: l.tastyCorner,
    english: 'Tasty Corner',
    logo: 'assets/images/ac2/kai_wei_shop_transparent.png',
    steps: [l.placeOrder, l.settleBill, l.collectFood],
  ),
];

class Ac2CanteenPage extends StatelessWidget {
  const Ac2CanteenPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('AC2 Canteen'),
      actions: const [LanguageSwitcher()],
    ),
    body: PageScroll(
      children: [
        InfoLine(Icons.place_outlined, context.l10n.ac2Location),
        const SizedBox(height: 8),
        InfoLine(Icons.schedule_outlined, context.l10n.dailyHours),
        SectionHeader(context.l10n.onlineOrdering),
        ResponsiveGrid(
          minItemWidth: 160,
          maxColumns: 4,
          children: [
            for (final s in _onlineStalls(context.l10n)) _StallCard(stall: s),
          ],
        ),
        SectionHeader(context.l10n.onSiteOrdering),
        ResponsiveGrid(
          minItemWidth: 160,
          maxColumns: 4,
          children: [
            for (final s in _offlineStalls(context.l10n)) _StallCard(stall: s),
          ],
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
                if (stall.english case final english?
                    when english != stall.name)
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.open_in_new, size: 18),
                    const SizedBox(width: 8),
                    Flexible(child: Text(context.l10n.orderNow)),
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
