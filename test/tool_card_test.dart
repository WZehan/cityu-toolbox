import 'package:cityu_toolbox/campus_tools.dart';
import 'package:cityu_toolbox/common_widgets.dart';
import 'package:cityu_toolbox/home_page.dart';
import 'package:cityu_toolbox/localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget toolGrid(List<CampusTool> tools, {double textScale = 1}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
    child: Scaffold(
      body: SingleChildScrollView(
        child: ResponsiveGrid(
          equalHeight: false,
          children: [for (final tool in tools) ToolCard(tool: tool)],
        ),
      ),
    ),
  ),
);

void expectTextInsideCards(WidgetTester tester) {
  for (final card in find.byType(Card).evaluate()) {
    final cardFinder = find.byWidget(card.widget);
    final bounds = tester.getRect(cardFinder);
    for (final text
        in find
            .descendant(of: cardFinder, matching: find.byType(Text))
            .evaluate()) {
      final textBounds = tester.getRect(find.byWidget(text.widget));
      expect(textBounds.top, greaterThanOrEqualTo(bounds.top));
      expect(textBounds.bottom, lessThanOrEqualTo(bounds.bottom));
      expect(textBounds.right, lessThanOrEqualTo(bounds.right));
    }
  }
  expect(tester.takeException(), isNull);
}

void main() {
  for (final width in [320.0, 390.0, 1200.0]) {
    testWidgets('Cards contain text on first layout and resize at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final language in AppLanguage.values) {
        final tools = allToolsFor(lookupAppLocalizations(language.locale));
        await tester.pumpWidget(toolGrid(tools));
        expectTextInsideCards(tester);

        // A later change in text metrics must grow the cards without filtering.
        await tester.pumpWidget(toolGrid(tools, textScale: 1.5));
        expectTextInsideCards(tester);

        if (width == 1200) {
          final cards = find.byType(Card);
          expect(
            {
              for (var i = 0; i < 3; i++) tester.getSize(cards.at(i)).height,
            }.length,
            greaterThan(1),
          );
        }
      }
    });
  }

  testWidgets(
    'Demo notice appears only when hovering over the title info icon',
    (tester) async {
      final tool = studyTools.last;
      await tester.pumpWidget(toolGrid([tool]));
      expect(find.text(tool.notice!), findsNothing);
      final icon = find.byIcon(Icons.info_outline);
      final title = find.text(tool.title);
      expect(
        tester.getRect(icon).left,
        greaterThan(tester.getRect(title).right),
      );

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(icon));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text(tool.notice!), findsOneWidget);

      await mouse.moveTo(const Offset(1, 500));
      await tester.pumpAndSettle();
      expect(find.text(tool.notice!), findsNothing);
    },
  );
}
