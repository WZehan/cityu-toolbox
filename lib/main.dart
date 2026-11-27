import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'ac2_canteen_page.dart';
import 'home_page.dart';
import 'install_guide.dart';
import 'library_resources_page.dart';
import 'localization.dart';
import 'testimonial_page.dart';
import 'theme.dart';

void main() => runApp(const CityUToolbox());

class CityUToolbox extends StatefulWidget {
  const CityUToolbox({super.key, this.showInstallGuide = kIsWeb});

  final bool showInstallGuide;

  @override
  State<CityUToolbox> createState() => _CityUToolboxState();
}

class _CityUToolboxState extends State<CityUToolbox> {
  AppLanguage _language = AppLanguage.simplified;

  @override
  Widget build(BuildContext context) => AppLanguageScope(
    language: _language,
    onChanged: (language) => setState(() => _language = language),
    child: MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      locale: _language.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      routes: {
        '/': (_) => HomePage(showInstallGuide: widget.showInstallGuide),
        '/testimonial': (_) => const TestimonialPage(),
        '/install': (_) => const InstallGuidePage(),
        '/ac2': (_) => const Ac2CanteenPage(),
        '/library': (_) => const LibraryResourcesPage(),
      },
    ),
  );
}
