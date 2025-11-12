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

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'AI Fitness App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

