import 'package:flutter/material.dart';

class ToastUtil {
  ToastUtil._();

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

extension ToastExtension on BuildContext {
  void showToast(String message) {
    ToastUtil.show(this, message);
  }
}
