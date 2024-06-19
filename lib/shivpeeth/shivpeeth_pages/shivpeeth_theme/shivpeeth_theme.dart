import 'package:flutter/material.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_color.dart';
import 'package:shivpeeth_erp_system/shivpeeth/shivpeeth_gloabelclass/shivpeeth_fontstyle.dart';



class WireframeMythemes {
  static final lightTheme = ThemeData(

    primaryColor: WireframeColor.appcolor,
    primarySwatch: Colors.grey,
    textTheme: const TextTheme(),
    fontFamily: 'SourceSansProRegular',
    scaffoldBackgroundColor: WireframeColor.white,
    appBarTheme: AppBarTheme(
      iconTheme:  const IconThemeData(color: WireframeColor.black),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: sansproRegular.copyWith(
        color: WireframeColor.black,
        fontSize: 16,
      ),
      color: WireframeColor.transparent,
    ),
  );

  static final darkTheme = ThemeData(

    fontFamily: 'SourceSansProRegular',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: WireframeColor.white),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: sansproRegular.copyWith(
        color: WireframeColor.white,
        fontSize: 15,
      ),
      color: WireframeColor.transparent,
    ),
  );
}