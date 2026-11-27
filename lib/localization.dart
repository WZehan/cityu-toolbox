import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

export 'l10n/app_localizations.dart';

enum AppLanguage {
  simplified(
    '简体中文',
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ),
  traditional(
    '繁體中文',
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ),
  english('English', Locale('en'));

  const AppLanguage(this.label, this.locale);

  final String label;
  final Locale locale;
}

AppLocalizations get defaultStrings =>
    lookupAppLocalizations(AppLanguage.simplified.locale);

extension LocalizedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class AppLanguageScope extends InheritedWidget {
  const AppLanguageScope({
    super.key,
    required this.language,
    required this.onChanged,
    required super.child,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onChanged;

  static AppLanguageScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppLanguageScope>()!;

  @override
  bool updateShouldNotify(AppLanguageScope oldWidget) =>
      language != oldWidget.language;
}

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppLanguageScope.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: PopupMenuButton<AppLanguage>(
        icon: const Icon(Icons.translate),
        tooltip: context.l10n.selectLanguage,
        initialValue: scope.language,
        position: PopupMenuPosition.under,
        onSelected: scope.onChanged,
        itemBuilder: (context) => [
          for (final language in AppLanguage.values)
            CheckedPopupMenuItem(
              value: language,
              checked: language == scope.language,
              child: Text(language.label),
            ),
        ],
      ),
    );
  }
}
