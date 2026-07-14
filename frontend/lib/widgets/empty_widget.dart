import 'package:flutter/material.dart';
import '../config/design_tokens.dart';

class EmptyWidget extends StatelessWidget {
  final String message;

  const EmptyWidget({
    super.key,
    this.message = '暂无数据',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: DesignTokens.hintColor,
          ),
          const SizedBox(height: DesignTokens.spacing12),
          Text(
            message,
            style: DesignTokens.hintStyle,
          ),
        ],
      ),
    );
  }
}
