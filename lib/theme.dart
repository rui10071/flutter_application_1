import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


const Color kPrimaryColor = Color(0xFF38e07b);


const Color kBackgroundLight = Color(0xFFFFFFFF);
const Color kCardLight = Color(0xFFF3F4F6);
const Color kTextLight = Color(0xFF111827);
const Color kTextLightSecondary = Color(0xFF4B5563);


const Color kBackgroundDark = Color(0xFF122017);
const Color kCardDark = Color(0xFF1a2c22);
const Color kTextDark = Color(0xFFF9FAFB);
const Color kTextDarkSecondary = Color(0xFF9CA3AF);


const Color kHighlight = Color(0xFFEF4444);


final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);


final TextTheme kTextTheme = TextTheme(
  displayLarge: GoogleFonts.lexend(fontWeight: FontWeight.w700),
  displayMedium: GoogleFonts.lexend(fontWeight: FontWeight.w700),
  displaySmall: GoogleFonts.lexend(fontWeight: FontWeight.w700),
  headlineLarge: GoogleFonts.lexend(fontWeight: FontWeight.w700),
  headlineMedium: GoogleFonts.lexend(fontWeight: FontWeight.w700),
  headlineSmall: GoogleFonts.lexend(fontWeight: FontWeight.w700),
  titleLarge: GoogleFonts.lexend(fontWeight: FontWeight.w500),
  titleMedium: GoogleFonts.lexend(fontWeight: FontWeight.w500),
  titleSmall: GoogleFonts.lexend(fontWeight: FontWeight.w500),
  bodyLarge: GoogleFonts.notoSansJp(fontWeight: FontWeight.w400),
  bodyMedium: GoogleFonts.notoSansJp(fontWeight: FontWeight.w400),
  bodySmall: GoogleFonts.notoSansJp(fontWeight: FontWeight.w400),
  labelLarge: GoogleFonts.lexend(fontWeight: FontWeight.w500),
  labelMedium: GoogleFonts.lexend(fontWeight: FontWeight.w500),
  labelSmall: GoogleFonts.lexend(fontWeight: FontWeight.w500),
);


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kBackgroundLight,
  colorScheme: ColorScheme.light(
    primary: kPrimaryColor,
    surface: kCardLight,
    background: kBackgroundLight,
    onPrimary: Colors.white,
    onSurface: kTextLight,
    onBackground: kTextLight,
    error: kHighlight,
  ),
  textTheme: kTextTheme.apply(bodyColor: kTextLight, displayColor: kTextLight),
  iconTheme: IconThemeData(color: kTextLight),
  appBarTheme: AppBarTheme(
    backgroundColor: kBackgroundLight,
    elevation: 0,
    iconTheme: IconThemeData(color: kTextLight),
    titleTextStyle: kTextTheme.titleLarge?.copyWith(color: kTextLight),
  ),
  cardTheme: CardThemeData(
    color: kCardLight,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: kPrimaryColor,
    unselectedItemColor: kTextLightSecondary,
  ),
);


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kBackgroundDark,
  colorScheme: ColorScheme.dark(
    primary: kPrimaryColor,
    surface: kCardDark,
    background: kBackgroundDark,
    onPrimary: kTextDark,
    onSurface: kTextDark,
    onBackground: kTextDark,
    error: kHighlight,
  ),
  textTheme: kTextTheme.apply(bodyColor: kTextDark, displayColor: kTextDark),
  iconTheme: IconThemeData(color: kTextDark),
  appBarTheme: AppBarTheme(
    backgroundColor: kBackgroundDark,
    elevation: 0,
    iconTheme: IconThemeData(color: kTextDark),
    titleTextStyle: kTextTheme.titleLarge?.copyWith(color: kTextDark),
  ),
  cardTheme: CardThemeData(
    color: kCardDark,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kCardDark,
    selectedItemColor: kPrimaryColor,
    unselectedItemColor: kTextDarkSecondary,
  ),
);


