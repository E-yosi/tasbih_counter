import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasbih_counter/Components/statistics_service.dart';
import 'package:tasbih_counter/Pages/loading_screen.dart';
import 'package:tasbih_counter/Pages/greeting_page.dart';
import 'package:tasbih_counter/Pages/home_page.dart';
import 'package:tasbih_counter/Pages/History.dart';
import 'package:tasbih_counter/Pages/Statistics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('objectivesBox');
  await Hive.openBox('settingsBox');
  await Hive.openBox('historyBox');
  final statsBox = await Hive.openBox('statisticsBox');
  final statsService = StatisticsService(statsBox);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _colors = [
    Colors.blueGrey,
    Colors.brown,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.deepPurple,
    Colors.purple
  ];

  Color _getDarkerBackground(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    return hsl.withLightness(hsl.lightness * 0.7).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settingsBox').listenable(),
      builder: (context, box, _) {
        int index = box.get('themeIndex', defaultValue: 0);
        final primaryColor = _colors[index];
        final darkerBackground = _getDarkerBackground(primaryColor);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: _colors[index],
            appBarTheme: AppBarTheme(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              secondary: primaryColor.shade900,
              surface: primaryColor.shade900,
              background: darkerBackground,
              onPrimary: Colors.white,
              onBackground: Colors.white,
              onSurface: Colors.white,
            ),
            cardTheme: CardTheme(
              color: primaryColor.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
            ),
          ),
          initialRoute: '/loading',
          routes: {
            '/loading': (context) => LoadingScreen(),
            '/greeting': (context) => GreetingScreen(),
            '/home': (context) => HomePage(),
            '/history': (context) => HistoryScreen(),
            '/statistics': (context) => StatisticsScreen(),
          },
        );
      },
    );
  }
}