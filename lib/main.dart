import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meal_ver2/util/CustomTheme.dart';
import 'package:meal_ver2/util/notification_service.dart';
import 'package:meal_ver2/view/MobileMeal2View.dart';
import 'package:meal_ver2/viewmodel/CustomThemeMode.dart';
import 'package:provider/provider.dart';
import 'package:meal_ver2/viewmodel/MainViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/SelectBibleView.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/OptionView.dart';
import 'firebase_options.dart'; // Firebase 옵션 파일이 있어야 합니다.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화

  try {
    // 1) Firebase 먼저 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('Firebase initialized successfully.');

    // 2) SharedPreferences 초기화
    // final SharedPreferences sharedPreferences =
    // await SharedPreferences.getInstance();
    // print("Loaded Theme Index: ${sharedPreferences.getInt('themeIndex')}");

    // 3) 로케일 초기화
    await initializeDateFormatting('ko_KR', null);

  }  catch (e, st) {
    debugPrint('Error initializing in main(): $e');
    debugPrint('$st');
  }
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  print("Loaded Theme Index: ${sharedPreferences.getInt('themeIndex')}");
  await NotificationService.init();
  await NotificationService.scheduleDaily10amBible();
    // 4) runApp
    runApp(
      ChangeNotifierProvider(
        create: (context) => MainViewModel(sharedPreferences),
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      ValueListenableBuilder<ThemeMode>(
          valueListenable: MainViewModel.themeMode,
          builder: (context, themeMode, child) {
            return MaterialApp(
              darkTheme: CustomThemeData.dark,
              theme: CustomThemeData.light,
              themeMode: themeMode,
              locale: Locale('ko', 'KR'), // 한국어 설정
              supportedLocales: [
                Locale('en', 'US'),
                Locale('ko', 'KR'), // 한국어 추가
              ],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: LayoutBuilder(
                  builder: (context, constraints){
                    if (constraints.maxWidth > 600) {
                      return MobileMeal2View();
                    } else{
                      return MobileMeal2View();
                    }
                  }
              ),

              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: child!,
              ),
            );
          });
  }
}