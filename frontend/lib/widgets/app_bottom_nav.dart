import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_provider.dart';

/// 自定义三区底部导航：
/// [首页] [===== 扫码充电 =====] [我的]
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  static const _orange = Color(0xFFff7823);
  static const _gray = Color(0xFF666666);
  static const _white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Consumer<TabProvider>(
      builder: (context, tabProvider, child) {
        return Container(
          height: 60,
          decoration: const BoxDecoration(
            color: _white,
            border: Border(
              top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
            ),
          ),
          child: Row(
            children: [
              // ── 1. 首页 ──
              _TabItem(
                icon: Icons.home,
                label: '首页',
                isSelected: tabProvider.currentIndex == 0,
                selectedColor: _orange,
                unselectedColor: _gray,
                onTap: () => tabProvider.switchTab(0),
              ),

              // ── 2. 中间扫码充电大胶囊 ──
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 6,
                  ),
                  child: InkWell(
                    onTap: () => tabProvider.switchTab(1),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFff9033), Color(0xFFff4422)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apps, color: _white, size: 20),
                          SizedBox(width: 6),
                          Text(
                            '扫码充电',
                            style: TextStyle(
                              color: _white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── 3. 我的 ──
              _TabItem(
                icon: Icons.person_outline,
                label: '我的',
                isSelected: tabProvider.currentIndex == 2,
                selectedColor: _orange,
                unselectedColor: _gray,
                onTap: () => tabProvider.switchTab(2),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;
    return Expanded(
      flex: 2,
      child: InkWell(
        onTap: onTap,
        splashColor: selectedColor.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
