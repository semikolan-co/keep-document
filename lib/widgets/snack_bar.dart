import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  Color color,
  String message,
) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.down,
      duration: const Duration(milliseconds: 1000),
    ),
  );
}
