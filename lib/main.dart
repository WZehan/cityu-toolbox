import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ac2_canteen_page.dart';
import 'home_page.dart';
import 'install_guide.dart';
import 'library_resources_page.dart';
import 'testimonial_page.dart';
import 'theme.dart';

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
    theme: buildAppTheme(Brightness.light),
    darkTheme: buildAppTheme(Brightness.dark),
    routes: {
      '/': (_) => const HomePage(),
      '/testimonial': (_) => const TestimonialPage(),
      '/install': (_) => const InstallGuidePage(),
      '/ac2': (_) => const Ac2CanteenPage(),
      '/library': (_) => const LibraryResourcesPage(),
    },
  );
}
