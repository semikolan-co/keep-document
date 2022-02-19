import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String message;
  final String positiveBtnText;
  final String negativeBtnText;
  final Function onPostivePressed;
  final Function onNegativePressed;
  final double circularBorderRadius;

  CustomAlertDialog({
    required this.title,
    required this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    required this.positiveBtnText,
    required this.negativeBtnText,
    required this.onPostivePressed,
    required this.onNegativePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title) : null,
      content: message != null ? Text(message) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),

      actions: [
        negativeBtnText != null
            ? TextButton(
                child: Text(negativeBtnText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onNegativePressed();
                },
              )
            : Container(),
        positiveBtnText != null
            ? TextButton(
                child: Text(positiveBtnText),
                onPressed: () {
                  onPostivePressed();
                  Navigator.of(context).pop();
                },
              )
            : Container(),
      ],
    );
  }
}