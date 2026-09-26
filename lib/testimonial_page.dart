import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_widgets.dart';

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
const feePerCopy = 60;

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
          width: 560,
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
                  const SnackBar(content: Text('已复制，可粘贴至正式申请表')),
                );
              } catch (_) {
                if (!ctx.mounted) return;
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('复制失败，请在预览中手动选择并复制')),
                );
              }
            },
            icon: const Icon(Icons.content_copy_outlined, size: 18),
            label: const Text('复制全部'),
          ),
        ],
      ),
    );
  }

  Future<void> clear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('清空已填写的资料？'),
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

  Widget _field(int i) => TextFormField(
    controller: controllers[i],
    validator: (v) => validateField(i, v),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: switch (i) {
      2 => TextInputType.phone,
      6 => TextInputType.number,
      7 => TextInputType.emailAddress,
      _ => TextInputType.text,
    },
    textInputAction: i == 7 ? TextInputAction.done : TextInputAction.next,
    autocorrect: false,
    enableSuggestions: false,
    decoration: InputDecoration(
      labelText: fieldChinese[i],
      helperText: fieldLabels[i],
      hintText: i == 4 ? '例如 MSc Business Information System' : null,
    ),
    onChanged: i == 6 ? (_) => setState(() {}) : null,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final copies = validateField(6, controllers[6].text) == null
        ? int.parse(controllers[6].text.trim())
        : null;
    final onFee = scheme.onSecondaryContainer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('在读证明预填表'),
        actions: [
          IconButton(
            tooltip: '清空表单',
            onPressed: clear,
            icon: const Icon(Icons.restart_alt),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Form(
        key: form,
        child: PageScroll(
          maxWidth: 760,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '填写后可预览并复制英文资料，用于正式申请。本工具不会提交申请或生成证明，资料仅保留在当前页面。',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SectionHeader('基本信息'),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth >= 560 ? (c.maxWidth - 16) / 2 : c.maxWidth;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (var i = 0; i < fieldLabels.length; i++)
                      SizedBox(width: w, child: _field(i)),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.payments_outlined, color: onFee),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '费用参考：HK\$$feePerCopy / 份 / 课程',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: onFee,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '实际以学校最新公布为准',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onFee,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (copies != null)
                    Text(
                      '预计 HK\$${copies * feePerCopy}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: onFee,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SectionHeader('附加信息（可选）'),
            Card(
              child: Column(
                children: [
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('AIMS 中的联系地址'),
                    subtitle: const Text('Contact Address in AIMS'),
                    value: address,
                    onChanged: (v) => setState(() => address = v ?? false),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('授课语言'),
                    subtitle: const Text('Medium of Instruction'),
                    value: medium,
                    onChanged: (v) => setState(() => medium = v ?? false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: preview,
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text('预览并复制资料'),
            ),
          ],
        ),
      ),
    );
  }
}
