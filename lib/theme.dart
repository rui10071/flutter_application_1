import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryColor = Color(0xFF38e07b);
const Color kBackgroundLight = Color(0xFFf6f8f7);
const Color kBackgroundDark = Color(0xFF122017);
const Color kCardLight = Color(0xFFffffff);
const Color kCardDark = Color(0xFF1a2c22);
const Color kTextLight = Color(0xFF1f2937);
const Color kTextDark = Color(0xFFe5e7eb);
const Color kTextLightSecondary = Color(0xFF6b7280);
const Color kTextDarkSecondary = Color(0xFF9ca3af);
const Color kHighlight = Color(0xFFef4444);

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
    secondary: kPrimaryColor,
    surface: kCardLight,
    background: kBackgroundLight,
    onPrimary: kTextDark,
    onSecondary: kTextDark,
    onSurface: kTextLight,
    onBackground: kTextLight,
    error: kHighlight,
  ),
  textTheme: kTextTheme.apply(bodyColor: kTextLight, displayColor: kTextLight),
  cardTheme: CardThemeData(
    color: kCardLight,
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kBackgroundLight,
    elevation: 0,
    iconTheme: IconThemeData(color: kTextLight),
    titleTextStyle: kTextTheme.titleLarge?.copyWith(color: kTextLight),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kCardLight,
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
    secondary: kPrimaryColor,
    surface: kCardDark,
    background: kBackgroundDark,
    onPrimary: kTextDark,
    onSecondary: kTextDark,
    onSurface: kTextDark,
    onBackground: kTextDark,
    error: kHighlight,
  ),
  textTheme: kTextTheme.apply(bodyColor: kTextDark, displayColor: kTextDark),
  cardTheme: CardThemeData(
    color: kCardDark,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kBackgroundDark,
    elevation: 0,
    iconTheme: IconThemeData(color: kTextDark),
    titleTextStyle: kTextTheme.titleLarge?.copyWith(color: kTextDark),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kCardDark,
    selectedItemColor: kPrimaryColor,
    unselectedItemColor: kTextDarkSecondary,
  ),
);

