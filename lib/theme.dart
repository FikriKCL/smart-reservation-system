import 'package:flutter/material.dart';

const kGreen      = Color(0xFF10B981);
const kGreenLight = Color(0xFFD1FAE5);
const kGreenDark  = Color(0xFF059669);
const kSlate900   = Color(0xFF0F172A);
const kSlate800   = Color(0xFF1E293B);
const kSlate700   = Color(0xFF334155);
const kSlate600   = Color(0xFF475569);
const kSlate500   = Color(0xFF64748B);
const kSlate400   = Color(0xFF94A3B8);
const kSlate300   = Color(0xFFCBD5E1);
const kSlate200   = Color(0xFFE2E8F0);
const kSlate100   = Color(0xFFF1F5F9);
const kSlate50    = Color(0xFFF8FAFC);
const kAmber500   = Color(0xFFF59E0B);
const kAmber50    = Color(0xFFFFFBEB);

ThemeData buildTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: kSlate50,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
