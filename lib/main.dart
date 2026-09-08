import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/screens/main_screen.dart';
import 'package:flutter_travel_concept/util/const.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Constants.appName,
          theme: Constants.lightTheme,
          darkTheme: Constants.darkTheme,
          themeMode: currentMode,
          home: const MainScreen(),
        );
      },
    );
  }
}
