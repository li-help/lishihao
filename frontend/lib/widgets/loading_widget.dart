import 'package:flutter/material.dart';
import '../config/design_tokens.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: DesignTokens.primaryColor,
      ),
    );
  }
}
