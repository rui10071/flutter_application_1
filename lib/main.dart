import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'selection_screen.dart';
import 'details_screen.dart';
import 'execution_screen.dart';
import 'result_screen.dart';
import 'mydata_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Fitness App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

