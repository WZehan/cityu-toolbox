import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cityu_toolbox/main.dart';

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
  testWidgets('Complete form previews all values and optional information', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CityUToolbox());
    await tester.pumpAndSettle();
    await tester.tap(find.text('学在城大').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('开始填写'));
    await tester.tap(find.text('开始填写'));
    await tester.pumpAndSettle();
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
  for (final width in [390.0, 1200.0]) {
    testWidgets('Home filters and form navigation at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const CityUToolbox());
      await tester.pumpAndSettle();
      expect(find.text('AC1 线上点餐'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('学在城大').first);
      await tester.pumpAndSettle();
      expect(find.text('AC1 线上点餐'), findsNothing);
      await tester.ensureVisible(find.text('开始填写'));
      await tester.tap(find.text('开始填写'));
      await tester.pumpAndSettle();
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
