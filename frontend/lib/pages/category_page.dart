import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/design_tokens.dart';
import '../providers/tab_provider.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Consume TabProvider to stay in sync, even though this is a placeholder
    context.watch<TabProvider>();

    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTokens.primaryColor,
        title: const Text(
          '分类',
          style: DesignTokens.appBarTitleStyle,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '分类页面',
          style: TextStyle(
            fontSize: 18,
            color: DesignTokens.secondaryColor,
          ),
        ),
      ),
    );
  }
}
