import 'package:flutter/material.dart';
import 'link_launcher.dart';

const _onlineStalls = <_Ac2Stall>[
  _Ac2Stall(
    name: '四季茶坊',
    english: 'Tea House',
    logo: 'assets/images/ac2/tea_house.png',
    orderUrl: 'https://csd.order.place/home/store/612882',
  ),
  _Ac2Stall(
    name: 'Euro Gourmet',
    english: 'AC2 CANTEEN',
    logo: 'assets/images/ac2/euro_gourmet.png',
    orderUrl: 'https://csd.order.place/home/store/712882?_aigens_source=scan',
  ),
  _Ac2Stall(
    name: '西北麵館',
    english: 'XiBei Mian Guan',
    logo: 'assets/images/ac2/xibei_noodle.png',
    orderUrl:
        'https://csd.order.place/home/store/312882?_aigens_source=scan&catMode=false&mode=dinein',
  ),
  _Ac2Stall(
    name: '餃餃陣',
    english: 'Dumpling City Express',
    logo: 'assets/images/ac2/dumpling_city_express.png',
    orderUrl: 'https://csd.order.place/home/store/212882?_aigens_source=scan',
  ),
];

const _offlineStalls = <_Ac2Stall>[
  _Ac2Stall(
    name: '麻辣滾燙',
    logo: 'assets/images/ac2/mala_rolling.png',
    steps: ['挑选菜 Select Food', '按重量付款 Pay by Weight', '叫号取餐 Food Pick-up'],
  ),
  _Ac2Stall(
    name: '拾味',
    english: 'The Pick',
    logo: 'assets/images/ac2/the_pick.png',
    steps: ['排队 Queue Up', '选菜 Select Food', '付款 Settle the Bill'],
  ),
  _Ac2Stall(
    name: '開味小店',
    english: 'Tasty Corner',
    logo: 'assets/images/ac2/kai_wei_shop.png',
    steps: ['点餐 Place Order', '付款 Settle the Bill', '取餐 Food Pick-up'],
  ),
];

class Ac2CanteenPage extends StatelessWidget {
  const Ac2CanteenPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('AC2 窗口点餐')),
    body: SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          return SingleChildScrollView(
            padding: EdgeInsets.all(wide ? 32 : 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AC2 Canteen',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '李达三叶耀珍学术楼 3 楼 · 周一至周日 07:30–21:00',
                      style: TextStyle(color: Color(0xFF737989), height: 1.6),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '支持线上点餐的窗口排在前面，点击按钮将在浏览器打开点餐页面。',
                      style: TextStyle(color: Color(0xFF737989), height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    _StallGrid(stalls: _onlineStalls, wide: wide),
                    const Padding(
                      padding: EdgeInsets.only(top: 32, bottom: 8),
                      child: Text(
                        '现场点餐',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Text(
                      '以下窗口目前没有线上点餐链接，请按窗口展示的步骤现场点餐。',
                      style: TextStyle(color: Color(0xFF737989), height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    _StallGrid(stalls: _offlineStalls, wide: wide),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _StallGrid extends StatelessWidget {
  const _StallGrid({required this.stalls, required this.wide});
  final List<_Ac2Stall> stalls;
  final bool wide;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 14,
    runSpacing: 14,
    children: stalls
        .map(
          (stall) => SizedBox(
            width: wide ? 350 : double.infinity,
            child: _StallCard(stall: stall),
          ),
        )
        .toList(),
  );
}

class _StallCard extends StatelessWidget {
  const _StallCard({required this.stall});
  final _Ac2Stall stall;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    elevation: 0,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Color(0xFFE6E8EE)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  stall.logo,
                  width: 148,
                  height: 62,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const SizedBox(
                    width: 148,
                    height: 62,
                    child: Icon(Icons.restaurant_rounded),
                  ),
                ),
              ),
              const Spacer(),
              _StatusPill(online: stall.orderUrl != null),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            stall.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          if (stall.english case final english?) ...[
            Text(
              english,
              style: const TextStyle(fontSize: 12, color: Color(0xFF737989)),
            ),
            const SizedBox(height: 16),
          ] else
            const SizedBox(height: 12),
          if (stall.orderUrl case final url?)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => openExternalLink(context, url),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('前往线上点餐'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFC71555),
                ),
              ),
            )
          else ...[
            const Text(
              '用餐流程',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 8,
              children: [
                for (var i = 0; i < stall.steps.length; i++) ...[
                  _StepPill(stall.steps[i]),
                  if (i != stall.steps.length - 1)
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF9AA1AD),
                      size: 17,
                    ),
                ],
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.online});
  final bool online;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: online ? const Color(0xFFEAF5EF) : const Color(0xFFF1F2F5),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      child: Text(
        online ? '线上点餐' : '仅限现场',
        style: TextStyle(
          color: online ? const Color(0xFF347753) : const Color(0xFF737989),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class _StepPill extends StatelessWidget {
  const _StepPill(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFF4F5F7),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(label, style: const TextStyle(fontSize: 10, height: 1.2)),
  );
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
