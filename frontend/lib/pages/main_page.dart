import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_provider.dart';
import '../widgets/app_bottom_nav.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'me_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TabProvider>(
      builder: (context, tabProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: tabProvider.currentIndex,
            children: const [
              HomePage(),
              CategoryPage(),
              MePage(),
            ],
          ),
          bottomNavigationBar: const AppBottomNav(),
        );
      },
    );
  }
}
