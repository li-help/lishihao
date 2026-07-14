import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/tab_provider.dart';
import 'providers/banner_provider.dart';
import 'providers/category_provider.dart';
import 'providers/article_provider.dart';
import 'providers/user_provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ArticleProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
