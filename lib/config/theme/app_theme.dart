import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  final Color electusColor;

  final bool tenebristModusEts;

  AppTheme ({
    this.electusColor = const Color(0xFF1E1C36),
    this.tenebristModusEts = false
  });

  ThemeData getTheme() => ThemeData(
    colorSchemeSeed: electusColor,
    brightness: tenebristModusEts ? Brightness.dark : Brightness.light,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates()
      )
    );


  


}