import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/design_tokens.dart';
import '../providers/tab_provider.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TabProvider>(
      builder: (context, tabProvider, child) {
        return Container(
          height: DesignTokens.bottomNavHeight,
          decoration: const BoxDecoration(
            color: DesignTokens.whiteColor,
            border: Border(
              top: BorderSide(
                color: DesignTokens.dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: '首页',
                isSelected: tabProvider.currentIndex == 0,
                onTap: () => tabProvider.switchTab(0),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view,
                label: '分类',
                isSelected: tabProvider.currentIndex == 1,
                onTap: () => tabProvider.switchTab(1),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '我的',
                isSelected: tabProvider.currentIndex == 2,
                onTap: () => tabProvider.switchTab(2),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color color =
        isSelected ? DesignTokens.primaryColor : DesignTokens.hintColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: DesignTokens.primaryColor.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: DesignTokens.bottomNavIconSize,
              color: color,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: DesignTokens.bottomNavLabelSize,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
