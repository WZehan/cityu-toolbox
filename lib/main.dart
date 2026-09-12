import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'install_guide.dart';

const accent = Color(0xFFC71555);
const ink = Color(0xFF202635);
const muted = Color(0xFF737989);
const appBuildVersion = '1.0.1(2)';

void main() => runApp(const CityUToolbox());

class CityUToolbox extends StatelessWidget {
  const CityUToolbox({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '城大百宝箱 · CityU Toolbox',
    debugShowCheckedModeBanner: false,
    locale: const Locale('zh', 'CN'),
    supportedLocales: const [Locale('zh', 'CN'), Locale('en')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: ink),
        bodyLarge: TextStyle(color: ink),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E5EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E5EB)),
        ),
      ),
    ),
    routes: {
      '/': (_) => const HomePage(),
      '/testimonial': (_) => const TestimonialPage(),
      '/install': (_) => const InstallGuidePage(),
    },
  );
}

class CampusTool {
  final String title, english, detail, tag;
  final IconData icon;
  final Color color;
  final String? url;
  const CampusTool(
    this.title,
    this.english,
    this.detail,
    this.tag,
    this.icon,
    this.color, [
    this.url,
  ]);
}

const dining = [
  CampusTool(
    'AC1 城大食坊',
    'City Express',
    '位置：中银（香港）综合楼 5 楼\n营业时间：周一至周日 07:30–21:00',
    '线上点餐',
    Icons.ramen_dining_rounded,
    Color(0xFFCE7134),
    'https://csd.order.place/home/store/112870?mode=prekiosk',
  ),
  CampusTool(
    'AC2 Canteen',
    '李达三叶耀珍学术楼',
    '位置：李达三叶耀珍学术楼 3 楼\n营业时间：周一至周日 07:30–21:00',
    '线上点餐',
    Icons.rice_bowl_rounded,
    Color(0xFF558266),
    'https://csd.order.place/home/store/612882',
  ),
  CampusTool(
    'AC3 Bistro',
    '刘鸣炜学术楼',
    '位置：刘鸣炜学术楼 7 楼\n营业时间：周一至周六 07:30–21:00\n周日及公众假期休息',
    '线上点餐',
    Icons.restaurant_rounded,
    Color(0xFF657FC0),
    'https://pth5.qmai.cn/mp-monorepo-h5/web/index.html#/pages/takefood/index?store_id=221033&multi_id=328009',
  ),
];
const testimonial = CampusTool(
  '在读证明预填表',
  'Student testimonial',
  '提前整理申请资料，办事更从容。',
  '表单工具',
  Icons.description_outlined,
  accent,
);

Future<void> openExternal(BuildContext context, String url) async {
  try {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    if (!opened) throw StateError('Unable to open URL');
  } catch (_) {
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('暂时无法打开链接'),
        content: SelectableText('请复制链接，在浏览器中打开：\n$url'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int category = 0;
  String query = '';
  bool matches(CampusTool t) => '${t.title} ${t.english} ${t.detail} ${t.tag}'
      .toLowerCase()
      .contains(query.trim().toLowerCase());
  @override
  Widget build(BuildContext context) {
    final food = dining.where(matches).toList();
    final study = matches(testimonial);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 850;
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1160),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: wide ? 36 : 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/toolbox.png',
                              width: 42,
                              height: 42,
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '城大百宝箱',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'CityU Toolbox',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: muted,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (wide)
                              const Text(
                                '让校园生活，简单一点。',
                                style: TextStyle(color: muted),
                              ),
                            const SizedBox(width: 18),
                            const Icon(Icons.school_outlined, color: accent),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1160),
                        child: Padding(
                          padding: EdgeInsets.all(wide ? 36 : 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(wide ? 36 : 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFF8E9EF),
                                      Color(0xFFFEF2E9),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'YOUR CAMPUS COMPANION',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2,
                                              color: accent,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            '城大生活，一箱搞定。',
                                            style: TextStyle(
                                              fontSize: wide ? 34 : 26,
                                              fontWeight: FontWeight.w800,
                                              height: 1.3,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            '从今日三餐，到学习日常。\n你的校园实用入口，都在这里。',
                                            style: TextStyle(
                                              color: muted,
                                              height: 1.8,
                                            ),
                                          ),
                                          const SizedBox(height: 22),
                                          const Wrap(
                                            spacing: 10,
                                            runSpacing: 8,
                                            children: [
                                              HeroTag('4 个实用工具'),
                                              HeroTag('为 CityU 同学而做'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (wide)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 40,
                                        ),
                                        child: Image.asset(
                                          'assets/images/toolbox.png',
                                          width: 205,
                                          height: 190,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                              Flex(
                                direction: wide
                                    ? Axis.horizontal
                                    : Axis.vertical,
                                crossAxisAlignment: wide
                                    ? CrossAxisAlignment.center
                                    : CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    children: List.generate(
                                      3,
                                      (i) => ChoiceChip(
                                        label: Text(
                                          ['全部工具', '食在城大', '学在城大'][i],
                                        ),
                                        selected: category == i,
                                        showCheckmark: false,
                                        onSelected: (_) =>
                                            setState(() => category = i),
                                      ),
                                    ),
                                  ),
                                  if (wide)
                                    const Spacer()
                                  else
                                    const SizedBox(height: 16),
                                  SizedBox(
                                    width: wide ? 290 : double.infinity,
                                    child: TextField(
                                      onChanged: (v) =>
                                          setState(() => query = v),
                                      decoration: const InputDecoration(
                                        hintText: '搜索校园工具…',
                                        prefixIcon: Icon(Icons.search),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (category != 2 && food.isNotEmpty) ...[
                                const SectionTitle(
                                  '食在城大',
                                  '好好吃饭，才有力气奔赴下一堂课。',
                                  Icons.restaurant_outlined,
                                ),
                                ToolGrid(tools: food),
                              ],
                              if (category != 1 && study) ...[
                                const SectionTitle(
                                  '学在城大',
                                  '把琐事理好，把时间留给学习。',
                                  Icons.auto_stories_outlined,
                                ),
                                const ToolGrid(tools: [testimonial]),
                              ],
                              if ((category == 2 || food.isEmpty) &&
                                  (category == 1 || !study))
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 60),
                                  child: Center(
                                    child: Text(
                                      '没有找到相关工具，试试 AC1 或「在读证明」。',
                                      style: TextStyle(color: muted),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 32),
                              Material(
                                color: const Color(0xFFEDF0F5),
                                borderRadius: BorderRadius.circular(12),
                                clipBehavior: Clip.antiAlias,
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.add_to_home_screen_rounded,
                                    color: accent,
                                  ),
                                  title: const Text(
                                    '将应用添加至桌面',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: const Text('跟着图文指引，把城大百宝箱放到手机主屏幕。'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/install'),
                                ),
                              ),
                              const SizedBox(height: 32),
                              const Center(
                                child: Text(
                                  '城大百宝箱 · CityU Toolbox\n构建版本：$appBuildVersion\n学生便民工具 · 非香港城市大学官方应用',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 11,
                                    height: 1.9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HeroTag extends StatelessWidget {
  final String text;
  const HeroTag(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .75),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(text, style: const TextStyle(fontSize: 11, color: muted)),
  );
}

class SectionTitle extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  const SectionTitle(this.title, this.subtitle, this.icon, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 18),
    child: Row(
      children: [
        Icon(icon, size: 21, color: accent),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ToolGrid extends StatelessWidget {
  final List<CampusTool> tools;
  const ToolGrid({required this.tools, super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final columns = c.maxWidth >= 760
          ? 3
          : c.maxWidth >= 560
          ? 2
          : 1;
      final compact = c.maxWidth < 500;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: tools
            .map(
              (t) => SizedBox(
                width: (c.maxWidth - (columns - 1) * 16) / columns,
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Color(0xFFE6E8EE)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      if (t.url != null) {
                        openExternal(context, t.url!);
                      } else {
                        Navigator.pushNamed(context, '/testimonial');
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(compact ? 14 : 23),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: t.color.withValues(alpha: .10),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(t.icon, color: t.color, size: 27),
                              ),
                              const Spacer(),
                              Text(
                                t.tag,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: muted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Text(
                            t.title,
                            style: TextStyle(
                              fontSize: compact ? 16 : 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t.english,
                            style: const TextStyle(color: muted, fontSize: 11),
                          ),
                          const SizedBox(height: 13),
                          Text(
                            t.detail,
                            style: const TextStyle(
                              color: muted,
                              fontSize: 13,
                              height: 1.8,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Text(
                                t.url != null ? '前往点餐' : '开始填写',
                                style: TextStyle(
                                  color: t.color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                t.url != null
                                    ? Icons.open_in_new_rounded
                                    : Icons.arrow_forward_rounded,
                                color: t.color,
                                size: 17,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
    },
  );
}

const fieldLabels = [
  'Student Name',
  'Student No.',
  'Day-time Contact Phone No.',
  'HKID/Passport No.',
  'Program Title',
  'Department',
  'Total number of testimonial(s) required',
  'Email Address',
];
const fieldChinese = [
  '学生姓名',
  '学生编号',
  '日间联系电话',
  '香港身份证 / 护照号码',
  '课程名称',
  '所属学系',
  '所需证明份数',
  '电子邮箱',
];
String? validateField(int i, String? value) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return '请填写${fieldChinese[i]}';
  if (i == 6 &&
      (!RegExp(r'^[0-9]+$').hasMatch(v) || (int.tryParse(v) ?? 0) < 1)) {
    return '请输入大于 0 的整数';
  }
  if (i == 7 && !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)) {
    return '请输入有效的电子邮箱';
  }
  if (i == 2 && !RegExp(r'^\+?[0-9 ()-]{6,25}$').hasMatch(v)) {
    return '请输入有效的联系电话';
  }
  return null;
}

String buildSummary(List<String> values, bool address, bool medium) => [
  'Student Testimonial — Pre-filled Information',
  '',
  for (var i = 0; i < fieldLabels.length; i++)
    '${fieldLabels[i]}: ${values[i].trim()}',
  '',
  'Optional information to be included:',
  'Contact Address in AIMS: ${address ? "Yes" : "No"}',
  'Medium of Instruction: ${medium ? "Yes" : "No"}',
].join('\n');

class TestimonialPage extends StatefulWidget {
  const TestimonialPage({super.key});
  @override
  State<TestimonialPage> createState() => _TestimonialPageState();
}

class _TestimonialPageState extends State<TestimonialPage> {
  final form = GlobalKey<FormState>();
  final controllers = List.generate(
    8,
    (i) => TextEditingController(text: i == 6 ? '1' : ''),
  );
  bool address = false, medium = false;
  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> preview() async {
    if (!form.currentState!.validate()) return;
    final summary = buildSummary(
      controllers.map((c) => c.text).toList(),
      address,
      medium,
    );
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('预填资料预览'),
        content: SizedBox(
          width: 580,
          child: SingleChildScrollView(
            child: SelectableText(summary, style: const TextStyle(height: 1.7)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('返回修改'),
          ),
          FilledButton.icon(
            onPressed: () async {
              try {
                await Clipboard.setData(ClipboardData(text: summary));
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已复制预填资料，可粘贴至正式申请表。')),
                );
              } catch (_) {
                if (!ctx.mounted) return;
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('复制失败，请在预览中手动选择并复制。')),
                );
              }
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('复制全部资料'),
          ),
        ],
      ),
    );
  }

  Future<void> clear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清空已填写资料？'),
        content: const Text('清空后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    form.currentState!.reset();
    for (var i = 0; i < controllers.length; i++) {
      controllers[i].text = i == 6 ? '1' : '';
    }
    setState(() {
      address = false;
      medium = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        '在读证明预填表',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student testimonial',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '提前准备，从容办理。',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '填写后可预览并复制英文资料，用于正式申请。此工具不会提交申请，也不会生成学校签发的证明。',
                      style: TextStyle(color: muted, height: 1.7),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(Icons.lock_outline, color: muted, size: 16),
                        SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            '资料仅保留在当前页面，离开或刷新后清除。',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (context, c) {
                        final w = c.maxWidth >= 640
                            ? (c.maxWidth - 20) / 2
                            : c.maxWidth;
                        return Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: List.generate(
                            8,
                            (i) => SizedBox(
                              width: w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${fieldChinese[i]} *',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    fieldLabels[i],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: muted,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: controllers[i],
                                    validator: (v) => validateField(i, v),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    keyboardType: i == 6
                                        ? TextInputType.number
                                        : i == 7
                                        ? TextInputType.emailAddress
                                        : i == 2
                                        ? TextInputType.phone
                                        : TextInputType.text,
                                    textInputAction: i == 7
                                        ? TextInputAction.done
                                        : TextInputAction.next,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: InputDecoration(
                                      hintText: i == 4
                                          ? '例如 MSc Business Information System'
                                          : '请输入${fieldChinese[i]}',
                                    ),
                                    onChanged: i == 6
                                        ? (_) => setState(() {})
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAEDF2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '费用参考：HK\$60 / 份 / 课程${validateField(6, controllers[6].text) == null ? " · 预计 HK\$${int.parse(controllers[6].text.trim()) * 60}" : ""}\n费用依据所提供文档，实际以学校最新公布为准。',
                        style: const TextStyle(
                          color: accent,
                          height: 1.7,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      '需要在证明中包含的信息（可选）',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('AIMS 中的联系地址'),
                      subtitle: const Text('Contact Address in AIMS'),
                      value: address,
                      onChanged: (v) => setState(() => address = v!),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('授课语言'),
                      subtitle: const Text('Medium of Instruction'),
                      value: medium,
                      onChanged: (v) => setState(() => medium = v!),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: preview,
                          icon: const Icon(Icons.fact_check_outlined),
                          label: const Text('预览并复制资料'),
                        ),
                        TextButton(onPressed: clear, child: const Text('清空表单')),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
