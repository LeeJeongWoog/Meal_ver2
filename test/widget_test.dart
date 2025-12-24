import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:meal_ver2/model/Verse.dart';
import 'package:meal_ver2/network/plan.dart';
import 'package:meal_ver2/view/MobileMeal2View.dart';
import 'package:meal_ver2/viewmodel/MainViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Meal2View renders provided verse data', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await initializeDateFormatting('ko_KR');
    Intl.defaultLocale = 'ko_KR';

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final viewModel = MainViewModel(prefs, initialize: false);

    final verse = Verse(
      bibleType: '[개역개정]',
      book: '창세기',
      btext: '태초에 하나님이 천지를 창조하시니라',
      fullName: '창세기',
      chapter: 1,
      id: 1,
      verse: 1,
    );

    viewModel.configureForTest(
      dataSource: [
        [verse]
      ],
      selectedBibles: ['개역개정'],
      todayPlan: Plan(
        book: '창세기',
        fullName: '창세기',
        fChap: 1,
        fVer: 1,
        lChap: 1,
        lVer: 1,
      ),
      selectedDate: DateTime(2024, 1, 1),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<MainViewModel>.value(
        value: viewModel,
        child: MobileMeal2View(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('태초에'), findsOneWidget);
  });
}
