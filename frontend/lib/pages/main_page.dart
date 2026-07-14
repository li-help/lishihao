import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_provider.dart';
import '../widgets/app_bottom_nav.dart';
import 'home_page.dart';
import 'me_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TabProvider>(
      builder: (context, tabProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: tabProvider.currentIndex > 2 ? 0 : tabProvider.currentIndex,
            children: const [
              HomePage(),
              _ScanPlaceholder(),
              MePage(),
            ],
          ),
          bottomNavigationBar: const AppBottomNav(),
        );
      },
    );
  }
}

/// 扫码充电占位页
class _ScanPlaceholder extends StatelessWidget {
  const _ScanPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_scanner, size: 80, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text('扫码充电', style: TextStyle(fontSize: 18, color: Color(0xFF999999))),
          ],
        ),
      ),
    );
  }
}
