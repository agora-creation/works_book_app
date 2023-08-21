import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kBackColor = Color(0xFFF4F5F7);
const kBaseColor = Color(0xFF3F51B5);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kGrey2Color = Color(0xFF757575);
const kGrey3Color = Color(0xFFCCCCCC);
const kRedColor = Color(0xFFF44336);
const kBlueColor = Color(0xFF2196F3);
const kOrangeColor = Color(0xFFFF9800);

ThemeData customTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kBackColor,
    fontFamily: 'SourceHanSansJP-Regular',
    appBarTheme: const AppBarTheme(
      color: kBackColor,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: kBaseColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
      iconTheme: IconThemeData(color: kBaseColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: kBaseColor),
      bodyMedium: TextStyle(color: kBaseColor),
      bodySmall: TextStyle(color: kBaseColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kWhiteColor,
      elevation: 5,
      selectedItemColor: kBaseColor,
      unselectedItemColor: kGrey2Color,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kBaseColor,
      elevation: 5,
      extendedTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    unselectedWidgetColor: kGreyColor,
  );
}

const kErrorStyle = TextStyle(
  color: kRedColor,
  fontSize: 14,
);

List<Color> kPlanColors = const [
  Color(0xFF2196F3),
  Color(0xFFF44336),
  Color(0xFF4CAF50),
  Color(0xFFFFC107),
];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));
