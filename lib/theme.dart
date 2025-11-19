import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


const Color kPrimaryColor = Color(0xFF39FF14);
const Color kHighlight = Color(0xFFFF0055);


const Color kBackgroundDark = Color(0xFF000000);
const Color kCardDark = Color(0xFF121212);
const Color kTextDark = Color(0xFFFFFFFF);
const Color kTextDarkSecondary = Color(0xB3FFFFFF);


final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);


final TextTheme kTextTheme = TextTheme(
  displayLarge: GoogleFonts.lexend(fontWeight: FontWeight.bold, color: kTextDark),
  displayMedium: GoogleFonts.lexend(fontWeight: FontWeight.bold, color: kTextDark),
  displaySmall: GoogleFonts.lexend(fontWeight: FontWeight.bold, color: kTextDark),
  headlineLarge: GoogleFonts.lexend(fontWeight: FontWeight.w700, color: kTextDark),
  headlineMedium: GoogleFonts.lexend(fontWeight: FontWeight.w700, color: kTextDark),
  headlineSmall: GoogleFonts.lexend(fontWeight: FontWeight.w700, color: kTextDark),
  titleLarge: GoogleFonts.lexend(fontWeight: FontWeight.w600, color: kTextDark),
  titleMedium: GoogleFonts.lexend(fontWeight: FontWeight.w600, color: kTextDark),
  titleSmall: GoogleFonts.lexend(fontWeight: FontWeight.w600, color: kTextDark),
  bodyLarge: GoogleFonts.notoSansJp(fontWeight: FontWeight.w400, color: kTextDark),
  bodyMedium: GoogleFonts.notoSansJp(fontWeight: FontWeight.w400, color: kTextDarkSecondary),
  bodySmall: GoogleFonts.notoSansJp(fontWeight: FontWeight.w400, color: kTextDarkSecondary),
  labelLarge: GoogleFonts.lexend(fontWeight: FontWeight.w600, color: kTextDark),
  labelMedium: GoogleFonts.lexend(fontWeight: FontWeight.w500, color: kTextDark),
  labelSmall: GoogleFonts.lexend(fontWeight: FontWeight.w500, color: kTextDarkSecondary),
);


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kBackgroundDark,
  colorScheme: ColorScheme.dark(
    primary: kPrimaryColor,
    secondary: kPrimaryColor,
    surface: kCardDark,
    background: kBackgroundDark,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: kTextDark,
    onBackground: kTextDark,
    error: kHighlight,
  ),
  textTheme: kTextTheme,
  iconTheme: IconThemeData(color: kTextDark),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: kTextDark),
    titleTextStyle: GoogleFonts.lexend(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: kTextDark,
    ),
  ),
  cardTheme: CardThemeData(
    color: kCardDark,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kBackgroundDark,
    selectedItemColor: kPrimaryColor,
    unselectedItemColor: Colors.white38,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.black,
      elevation: 0,
      textStyle: GoogleFonts.lexend(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: kPrimaryColor,
      side: BorderSide(color: kPrimaryColor),
      textStyle: GoogleFonts.lexend(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kPrimaryColor,
      textStyle: GoogleFonts.lexend(fontWeight: FontWeight.bold),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.05),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: kPrimaryColor),
    ),
    hintStyle: GoogleFonts.notoSansJp(color: Colors.white38),
    labelStyle: GoogleFonts.notoSansJp(color: Colors.white70),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.white.withOpacity(0.1),
    thickness: 1,
  ),
);


ThemeData lightTheme = darkTheme;


