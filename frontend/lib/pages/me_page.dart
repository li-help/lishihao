import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/design_tokens.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/cached_image.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          backgroundColor: DesignTokens.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildUserHeader(userProvider.user),
                _buildStatsBar(userProvider.user),
                _buildMenuList(),
                const SizedBox(height: DesignTokens.spacing16),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── 1. User Header ──────────────────────────────────────
  Widget _buildUserHeader(UserModel user) {
    return Container(
      height: 160,
      padding: const EdgeInsets.only(
        top: 30,
        left: DesignTokens.spacing16,
        right: DesignTokens.spacing16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignTokens.primaryColor,
            Color(0xFF60A5FA),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: DesignTokens.whiteColor,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: AppCachedImage(
                imageUrl: user.avatar,
                width: 72,
                height: 72,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacing16),
          // Name + ID
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nickName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.whiteColor,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacing4),
                Text(
                  'ID: ${user.userId}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: DesignTokens.whiteColor,
                  ),
                ),
              ],
            ),
          ),
          // Edit button
          InkWell(
            onTap: () {},
            splashColor: Colors.white24,
            borderRadius:
                BorderRadius.circular(DesignTokens.borderRadiusMedium),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing12,
                vertical: DesignTokens.spacing4,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: DesignTokens.whiteColor),
                borderRadius:
                    BorderRadius.circular(DesignTokens.borderRadiusMedium),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: DesignTokens.whiteColor,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '编辑',
                    style: TextStyle(
                      fontSize: 12,
                      color: DesignTokens.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 2. Stats Bar ────────────────────────────────────────
  Widget _buildStatsBar(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: DesignTokens.spacing12,
        horizontal: DesignTokens.spacing16,
      ),
      height: 80,
      decoration: BoxDecoration(
        color: DesignTokens.whiteColor,
        borderRadius:
            BorderRadius.circular(DesignTokens.borderRadiusMedium),
      ),
      child: Row(
        children: [
          _buildStatItem(
            value: '${user.points}',
            label: '积分',
          ),
          _buildStatDivider(),
          _buildStatItem(
            value: '${user.collectCount}',
            label: '收藏',
          ),
          _buildStatDivider(),
          _buildStatItem(
            value: '${user.viewCount}',
            label: '浏览',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: DesignTokens.titleColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          Text(
            label,
            style: DesignTokens.hintStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return const SizedBox(
      height: 36,
      child: VerticalDivider(
        color: DesignTokens.dividerColor,
        width: 1,
        thickness: 1,
      ),
    );
  }

  // ── 3. Menu List ────────────────────────────────────────
  Widget _buildMenuList() {
    final menuItems = [
      _MenuItem(Icons.receipt_long_outlined, '我的订单'),
      _MenuItem(Icons.card_giftcard_outlined, '我的优惠券'),
      _MenuItem(Icons.notifications_outlined, '消息通知'),
      _MenuItem(Icons.settings_outlined, '系统设置'),
      _MenuItem(Icons.info_outline, '关于我们'),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignTokens.spacing16),
      decoration: BoxDecoration(
        color: DesignTokens.whiteColor,
        borderRadius:
            BorderRadius.circular(DesignTokens.borderRadiusMedium),
      ),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == menuItems.length - 1;
          return _buildMenuRow(
            icon: item.icon,
            title: item.title,
            showDivider: !isLast,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          splashColor: DesignTokens.primaryColor.withOpacity(0.1),
          child: SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing16,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: DesignTokens.menuIconSize,
                    color: DesignTokens.primaryColor,
                  ),
                  const SizedBox(width: DesignTokens.spacing12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: DesignTokens.bodyColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: DesignTokens.hintColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 52),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: DesignTokens.dividerColor,
            ),
          ),
      ],
    );
  }
}

// ── Helper class for menu items ───────────────────────────
class _MenuItem {
  final IconData icon;
  final String title;

  const _MenuItem(this.icon, this.title);
}
