import 'package:flutter/material.dart';
import 'config/design_tokens.dart';
import 'pages/main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '首页展示',
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'CN'),
      supportedLocales: const [
        Locale('zh', 'CN'),
      ],
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: DesignTokens.primaryColor,
        scaffoldBackgroundColor: DesignTokens.backgroundColor,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: DesignTokens.whiteColor,
          selectedItemColor: DesignTokens.primaryColor,
          unselectedItemColor: DesignTokens.hintColor,
          selectedLabelStyle: TextStyle(fontSize: DesignTokens.bottomNavLabelSize),
          unselectedLabelStyle: TextStyle(fontSize: DesignTokens.bottomNavLabelSize),
        ),
      ),
      home: const MainPage(),
    );
  }
}
