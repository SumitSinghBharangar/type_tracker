import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:type_tracker/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData.light(), // Light Theme
            darkTheme: ThemeData.dark(), // Dark Theme
            themeMode: ThemeMode.system, // System-based theme switching
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        });
  }
}
