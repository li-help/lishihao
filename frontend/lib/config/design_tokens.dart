import 'package:flutter/material.dart';

class DesignTokens {
  DesignTokens._();

  // ── Colors ──────────────────────────────────────────────
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color titleColor = Color(0xFF222222);
  static const Color bodyColor = Color(0xFF333333);
  static const Color secondaryColor = Color(0xFF666666);
  static const Color hintColor = Color(0xFF999999);
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color inactiveDotColor = Color(0xFFCCCCCC);

  // ── Border Radius ───────────────────────────────────────
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double avatarBorderRadius = 50.0;

  // ── Spacing ─────────────────────────────────────────────
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;

  // ── Sizes ───────────────────────────────────────────────
  static const double appBarHeight = 48.0;
  static const double bottomNavHeight = 60.0;
  static const double appBarIconSize = 22.0;
  static const double tabIconSize = 24.0;
  static const double menuIconSize = 24.0;
  static const double bottomNavIconSize = 24.0;
  static const double bottomNavLabelSize = 11.0;

  // ── Text Styles ─────────────────────────────────────────
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: titleColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14.0,
    color: bodyColor,
  );

  static const TextStyle secondaryStyle = TextStyle(
    fontSize: 13.0,
    color: secondaryColor,
  );

  static const TextStyle hintStyle = TextStyle(
    fontSize: 12.0,
    color: hintColor,
  );

  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: whiteColor,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: titleColor,
  );

  static const TextStyle linkTextStyle = TextStyle(
    fontSize: 13.0,
    color: primaryColor,
  );
}
