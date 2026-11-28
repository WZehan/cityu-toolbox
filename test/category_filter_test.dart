import 'package:cityu_toolbox/home_page.dart';
import 'package:cityu_toolbox/localization.dart';
import 'package:cityu_toolbox/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

Widget homeIn(AppLanguage language, double scale) => AppLanguageScope(
  language: language,
  onChanged: (_) {},
  child: MaterialApp(
    locale: language.locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    theme: buildAppTheme(Brightness.light),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: child!,
    ),
    home: const HomePage(showInstallGuide: false),
  ),
);

void expectSingleLineFilters(WidgetTester tester, AppLocalizations strings) {
  for (final label in [strings.all, strings.dining, strings.study]) {
    final text = find.text(label).first;
    final button = find
        .ancestor(of: text, matching: find.byType(InkWell))
        .first;
    final bounds = tester.getRect(button);
    final textBounds = tester.getRect(text);
    expect(bounds.contains(textBounds.topLeft), isTrue);
    expect(bounds.contains(textBounds.bottomRight), isTrue);
    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(of: text, matching: find.byType(RichText)),
    );
    final lines = paragraph.getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: label.length),
    );
    expect(lines.map((box) => box.top).toSet(), hasLength(1));
    expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
  }
  expect(tester.takeException(), isNull);
}

void main() {
  for (final width in [320.0, 390.0, 720.0, 1200.0]) {
    testWidgets('Category labels fit on first load and font change at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final language in AppLanguage.values) {
        for (final scale in [1.0, 1.6]) {
          // Start a fresh home page in each language, without toggling filters.
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpWidget(homeIn(language, scale));
          await tester.pumpAndSettle();
          final strings = lookupAppLocalizations(language.locale);
          expectSingleLineFilters(tester, strings);

          await tester.binding.handleSystemMessage({'type': 'fontsChange'});
          await tester.pump();
          expectSingleLineFilters(tester, strings);

          final study = find.text(strings.study).first;
          await tester.ensureVisible(study);
          await tester.tap(study);
          await tester.pumpAndSettle();
          expect(find.text(strings.panoramaNavigation), findsOneWidget);
          expect(find.text(strings.ac1Title), findsNothing);
        }
      }
    });
  }
}
