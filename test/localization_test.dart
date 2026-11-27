import 'package:cityu_toolbox/campus_tools.dart';
import 'package:cityu_toolbox/localization.dart';
import 'package:cityu_toolbox/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> changeLanguage(WidgetTester tester, String label) async {
  await tester.tap(find.byType(PopupMenuButton<AppLanguage>));
  await tester.pumpAndSettle();
  expect(find.byType(CheckedPopupMenuItem<AppLanguage>), findsNWidgets(3));
  expect(
    tester
        .widgetList<CheckedPopupMenuItem<AppLanguage>>(
          find.byType(CheckedPopupMenuItem<AppLanguage>),
        )
        .where((item) => item.checked),
    hasLength(1),
  );
  await tester.tap(
    find.ancestor(
      of: find.text(label),
      matching: find.byType(CheckedPopupMenuItem<AppLanguage>),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.byType(CheckedPopupMenuItem<AppLanguage>), findsNothing);
}

Future<void> openPage(WidgetTester tester, String title) async {
  await tester.ensureVisible(find.text(title));
  await tester.tap(find.text(title));
  await tester.pumpAndSettle();
}

void main() {
  test('Public resource booking retains its destination in all languages', () {
    for (final language in AppLanguage.values) {
      final strings = lookupAppLocalizations(language.locale);
      final booking = studyToolsFor(strings)[1];
      expect(booking.title, strings.publicResources);
      expect(booking.url, 'https://booking.cityu.edu.hk/app/booking-types');
      expect(booking.matches('公共资源预约'), isTrue);
      expect(booking.matches('公共資源預約'), isTrue);
      expect(booking.matches('Public Resource Booking'), isTrue);
    }
  });

  for (final width in [320.0, 390.0, 1200.0]) {
    testWidgets('Language menu and page layouts at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const CityUToolbox(showInstallGuide: true));
      await tester.pumpAndSettle();

      expect(find.text('公共资源预约'), findsOneWidget);
      expect(find.text('图书馆座位预约'), findsNothing);
      expect(find.byType(PopupMenuButton<AppLanguage>), findsOneWidget);
      expect(find.text('English'), findsNothing);
      expect(tester.getCenter(find.byIcon(Icons.translate)).dy, lessThan(80));
      expect(tester.takeException(), isNull);

      await changeLanguage(tester, '繁體中文');
      expect(find.text('城大百寶箱'), findsOneWidget);
      expect(find.text('公共資源預約'), findsOneWidget);
      expect(find.text('學在城大'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      await openPage(tester, '圖書館資源');
      expect(find.text('搜尋館藏'), findsOneWidget);
      expect(find.text('八校通申請'), findsOneWidget);
      await changeLanguage(tester, 'English');
      expect(find.text('Library Resources'), findsOneWidget);
      expect(find.text('Search the catalogue'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Public Resource Booking'), findsOneWidget);
      expect(find.text('CityU Toolbox'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await openPage(tester, 'AC2 Canteen');
      expect(find.text('Order now'), findsNWidgets(4));
      expect(find.text('Tea House'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await openPage(tester, 'Add to Home Screen');
      expect(find.text('Choose Add to Home Screen'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await changeLanguage(tester, '简体中文');
      expect(find.text('公共资源预约'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Changing language preserves filters, search and form input', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CityUToolbox());
    await tester.pumpAndSettle();
    await tester.tap(find.text('学在城大').first);
    await tester.enterText(find.byType(TextField), 'public');
    await tester.pumpAndSettle();
    await changeLanguage(tester, 'English');
    expect(find.text('Public Resource Booking'), findsOneWidget);
    expect(find.text('AC2 Canteen'), findsNothing);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'public',
    );
    await tester.tap(find.byTooltip('Clear'));
    await tester.pumpAndSettle();
    await openPage(tester, 'Testimonial Pre-fill');
    await tester.enterText(find.byType(TextFormField).first, 'Test Student');
    await changeLanguage(tester, '繁體中文');
    expect(find.text('Test Student'), findsOneWidget);
    expect(find.text('學生姓名'), findsOneWidget);
    await tester.ensureVisible(find.text('預覽並複製資料'));
    await tester.tap(find.text('預覽並複製資料'));
    await tester.pumpAndSettle();
    expect(find.text('請填寫學生編號'), findsOneWidget);
    await changeLanguage(tester, 'English');
    await tester.ensureVisible(find.text('Preview and copy details'));
    await tester.tap(find.text('Preview and copy details'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter Student number'), findsOneWidget);
    expect(find.text('Test Student'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
