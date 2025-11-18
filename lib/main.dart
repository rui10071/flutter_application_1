import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'theme.dart';
import 'login_or_signup_screen.dart';
import 'main_screen.dart';
import 'repositories.dart';
import 'providers.dart';


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
    final authState = ref.watch(authStateProvider);


    return MaterialApp(
      title: 'MIRRORSENSE',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark, // 強制ダークモード
      debugShowCheckedModeBanner: false,
      
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja', 'JP'), 
      ],


      home: authState.when(
        data: (userId) {
          if (userId != null) {
            return MainScreen();
          } else {
            return LoginOrSignupScreen(); 
          }
        },
        loading: () => _buildSplashScreen(),
        error: (e, stack) => _buildErrorScreen(e),
      ),
    );
  }


  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildErrorScreen(Object error) {
    return Scaffold(
      body: Center(
        child: Text("起動エラーが発生しました: $error"),
      ),
    );
  }
}


