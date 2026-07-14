import 'package:flutter/material.dart';
import '../config/design_tokens.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: DesignTokens.hintColor,
          ),
          const SizedBox(height: DesignTokens.spacing12),
          Text(
            message,
            style: DesignTokens.secondaryStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacing16),
          InkWell(
            onTap: onRetry,
            splashColor: DesignTokens.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSmall),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacing16,
                vertical: DesignTokens.spacing8,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: DesignTokens.primaryColor),
                borderRadius:
                    BorderRadius.circular(DesignTokens.borderRadiusSmall),
              ),
              child: const Text(
                '点击重试',
                style: DesignTokens.linkTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
