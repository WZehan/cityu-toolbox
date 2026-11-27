import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_widgets.dart';
import 'localization.dart';

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
List<String> localizedFieldLabels(AppLocalizations l) => [
  l.studentName,
  l.studentNumber,
  l.contactPhone,
  l.identityNumber,
  l.programTitle,
  l.department,
  l.copiesRequired,
  l.emailAddress,
];
const feePerCopy = 60;

String? validateField(int i, String? value, [AppLocalizations? strings]) {
  final l = strings ?? defaultStrings;
  final v = value?.trim() ?? '';
  if (v.isEmpty) return l.requiredField(localizedFieldLabels(l)[i]);
  if (i == 6 &&
      (!RegExp(r'^[0-9]+$').hasMatch(v) || (int.tryParse(v) ?? 0) < 1)) {
    return l.positiveInteger;
  }
  if (i == 7 && !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)) {
    return l.validEmail;
  }
  if (i == 2 && !RegExp(r'^\+?[0-9 ()-]{6,25}$').hasMatch(v)) {
    return l.validPhone;
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
        title: Text(ctx.l10n.previewTitle),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: SelectableText(summary, style: const TextStyle(height: 1.7)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(ctx.l10n.backToEdit),
          ),
          FilledButton.icon(
            onPressed: () async {
              try {
                await Clipboard.setData(ClipboardData(text: summary));
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.copiedDetails)),
                );
              } catch (_) {
                if (!ctx.mounted) return;
                ScaffoldMessenger.of(
                  ctx,
                ).showSnackBar(SnackBar(content: Text(ctx.l10n.copyFailed)));
              }
            },
            icon: const Icon(Icons.content_copy_outlined, size: 18),
            label: Text(ctx.l10n.copyAll),
          ),
        ],
      ),
    );
  }

  Future<void> clear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.clearFormTitle),
        content: Text(ctx.l10n.clearFormMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.clearConfirm),
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
    validator: (v) => validateField(i, v, context.l10n),
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
      labelText: localizedFieldLabels(context.l10n)[i],
      helperText: Localizations.localeOf(context).languageCode == 'en'
          ? null
          : fieldLabels[i],
      hintText: i == 4 ? context.l10n.programHint : null,
    ),
    onChanged: i == 6 ? (_) => setState(() {}) : null,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final scheme = theme.colorScheme;
    final copies = validateField(6, controllers[6].text) == null
        ? int.parse(controllers[6].text.trim())
        : null;
    final onFee = scheme.onSecondaryContainer;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.testimonial),
        actions: [
          IconButton(
            tooltip: l.clearForm,
            onPressed: clear,
            icon: const Icon(Icons.restart_alt),
          ),
          const SizedBox(width: 4),
          const LanguageSwitcher(),
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
                      l.formNotice,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SectionHeader(l.basicInformation),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth >= 560
                    ? (c.maxWidth - 16) / 2
                    : c.maxWidth;
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
                          l.feeReference(feePerCopy),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: onFee,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l.feeDisclaimer,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onFee,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (copies != null)
                    Text(
                      l.estimatedFee(copies * feePerCopy),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: onFee,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            SectionHeader(l.optionalInformation),
            Card(
              child: Column(
                children: [
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(l.contactAddress),
                    subtitle:
                        Localizations.localeOf(context).languageCode == 'en'
                        ? null
                        : const Text('Contact Address in AIMS'),
                    value: address,
                    onChanged: (v) => setState(() => address = v ?? false),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(l.mediumInstruction),
                    subtitle:
                        Localizations.localeOf(context).languageCode == 'en'
                        ? null
                        : const Text('Medium of Instruction'),
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
              label: Text(l.previewAndCopy),
            ),
          ],
        ),
      ),
    );
  }
}
