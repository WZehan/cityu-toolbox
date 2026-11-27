import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cityu_toolbox/app_info.dart';
import 'package:cityu_toolbox/campus_tools.dart';
import 'package:cityu_toolbox/library_resources_page.dart';
import 'package:cityu_toolbox/main.dart';
import 'package:cityu_toolbox/testimonial_page.dart';

void setViewWidth(WidgetTester tester, double width) {
  tester.view.physicalSize = Size(width, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> openTool(WidgetTester tester, String title) async {
  await tester.ensureVisible(find.text(title));
  await tester.pumpAndSettle();
  await tester.tap(find.text(title));
  await tester.pumpAndSettle();
}

void main() {
  test('Validates required values, email and positive copy count', () {
    expect(validateField(0, '  '), isNotNull);
    for (final n in ['0', '-1', '1.5', 'abc']) {
      expect(validateField(6, n), isNotNull);
    }
    expect(validateField(6, '2'), isNull);
    expect(validateField(7, 'bad@'), isNotNull);
    expect(validateField(7, 'student@my.cityu.edu.hk'), isNull);
    expect(validateField(2, '+852 1234 5678'), isNull);
  });

  test('Summary includes all fields and independent optional flags', () {
    final text = buildSummary(
      [
        'Test Student',
        '12345678',
        '+852 1234 5678',
        'P1234567',
        'MSc Test',
        'Test Department',
        '2',
        'test@example.com',
      ],
      true,
      false,
    );
    expect(text, contains('Student No.: 12345678'));
    expect(text, contains('Contact Address in AIMS: Yes'));
    expect(text, contains('Medium of Instruction: No'));
    expect(text, contains('Total number of testimonial(s) required: 2'));
  });

  test('Uses AC1 pre-kiosk URL and exposes the build version', () {
    expect(
      diningTools.first.url,
      'https://csd.order.place/home/store/112870?mode=prekiosk',
    );
    expect(appBuildVersion, '1.0.4+7');
  });

  test('Tool search matches hidden English keywords and info lines', () {
    expect(studyTools.first.matches('library'), isTrue);
    expect(diningTools.last.matches('公众假期'), isTrue);
    expect(diningTools.first.matches('library'), isFalse);
  });

  test('LibraryFind adds an encoded keyword to the supplied search URL', () {
    expect(
      libraryFindSearchUrl('machine learning'),
      '${libraryFindBaseUrl}machine%20learning',
    );
  });

  testWidgets('AC2 shows all online stalls before the on-site stalls', (
    tester,
  ) async {
    setViewWidth(tester, 390);
    await tester.pumpWidget(const CityUToolbox());
    await tester.pumpAndSettle();
    await openTool(tester, 'AC2 Canteen');
    expect(find.text('去点餐'), findsNWidgets(4));
    for (final name in [
      '四季茶坊',
      'Euro Gourmet',
      '西北麵館',
      '餃餃陣',
      '麻辣滾燙',
      '拾味',
      '開味小店',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
    expect(
      tester.getTopLeft(find.text('餃餃陣')).dy,
      lessThan(tester.getTopLeft(find.text('麻辣滾燙')).dy),
    );
    expect(find.text('排队 Queue Up'), findsOneWidget);
    expect(find.text('付款 Settle the Bill'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Library card opens a page with search and resource links', (
    tester,
  ) async {
    setViewWidth(tester, 390);
    await tester.pumpWidget(const CityUToolbox());
    await tester.pumpAndSettle();
    await tester.tap(find.text('学在城大').first);
    await tester.pumpAndSettle();
    await openTool(tester, '图书馆资源');
    expect(find.text('搜索馆藏'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('八校通申请'), findsOneWidget);
    expect(find.text('学术资源'), findsOneWidget);
    expect(find.text('往年考试试题下载'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Complete form previews all values and optional information', (
    tester,
  ) async {
    setViewWidth(tester, 390);
    await tester.pumpWidget(const CityUToolbox());
    await tester.pumpAndSettle();
    await openTool(tester, '在读证明预填表');
    final values = [
      'Test Student',
      '12345678',
      '+852 1234 5678',
      'P1234567',
      'MSc Test',
      'Test Department',
      '2',
      'test@example.com',
    ];
    for (var i = 0; i < values.length; i++) {
      await tester.ensureVisible(find.byType(TextFormField).at(i));
      await tester.enterText(find.byType(TextFormField).at(i), values[i]);
    }
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    expect(find.text('预计 HK\$120'), findsOneWidget);
    await tester.ensureVisible(find.byType(CheckboxListTile).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile).last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('预览并复制资料'));
    await tester.tap(find.text('预览并复制资料'));
    await tester.pumpAndSettle();
    expect(find.text('预填资料预览'), findsOneWidget);
    expect(find.textContaining('Medium of Instruction: Yes'), findsOneWidget);
    expect(
      find.textContaining('Email Address: test@example.com'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Install guide is reachable from the home page on web', (
    tester,
  ) async {
    setViewWidth(tester, 390);
    await tester.pumpWidget(const CityUToolbox(showInstallGuide: true));
    await tester.pumpAndSettle();
    await openTool(tester, '添加到主屏幕');
    expect(find.text('iPhone / iPad · Safari'), findsOneWidget);
    expect(find.text('选择「添加到主屏幕」'), findsOneWidget);
    expect(find.text('确认名称，点击「添加」'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Renders in dark mode without layout errors', (tester) async {
    setViewWidth(tester, 390);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(const CityUToolbox());
    await tester.pumpAndSettle();
    expect(find.text('AC1 城大食坊'), findsOneWidget);
    await openTool(tester, 'AC2 Canteen');
    expect(tester.takeException(), isNull);
  });

  for (final width in [390.0, 1200.0]) {
    testWidgets('Home layout, search and filters at width $width', (
      tester,
    ) async {
      setViewWidth(tester, width);
      await tester.pumpWidget(const CityUToolbox());
      await tester.pumpAndSettle();
      expect(find.text('AC1 城大食坊'), findsOneWidget);
      expect(find.textContaining('构建版本 1.0.4+7'), findsOneWidget);
      final ac1 = tester.getTopLeft(find.text('AC1 城大食坊'));
      final ac2 = tester.getTopLeft(find.text('AC2 Canteen'));
      if (width == 390) {
        expect(ac2.dx, ac1.dx);
        expect(ac2.dy, greaterThan(ac1.dy));
      } else {
        expect(ac2.dx, greaterThan(ac1.dx));
        expect(ac2.dy, ac1.dy);
      }
      expect(find.text('周日及公众假期休息'), findsOneWidget);
      // Promotional copy has been removed.
      expect(find.text('YOUR CAMPUS COMPANION'), findsNothing);

      await tester.enterText(find.byType(TextField), 'library');
      await tester.pumpAndSettle();
      expect(find.text('AC1 城大食坊'), findsNothing);
      expect(find.text('图书馆资源'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('没有找到相关工具'), findsOneWidget);
      await tester.tap(find.byTooltip('清除'));
      await tester.pumpAndSettle();
      expect(find.text('AC1 城大食坊'), findsOneWidget);

      await tester.tap(find.text('学在城大').first);
      await tester.pumpAndSettle();
      expect(find.text('AC1 城大食坊'), findsNothing);
      await openTool(tester, '在读证明预填表');
      expect(find.text('Student Name'), findsOneWidget);
      await tester.ensureVisible(find.text('预览并复制资料'));
      await tester.tap(find.text('预览并复制资料'));
      await tester.pumpAndSettle();
      expect(find.text('请填写学生姓名'), findsOneWidget);
      expect(find.text('预填资料预览'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
