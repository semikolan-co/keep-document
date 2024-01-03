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
      // ignore: unnecessary_null_comparison
      title: title != null ? Text(title) : null,

      // ignore: unnecessary_null_comparison
      content: message != null ? Text(message) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: [
        // ignore: unnecessary_null_comparison
        negativeBtnText != null
            ? TextButton(
                child: Text(negativeBtnText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onNegativePressed();
                },
              )
            : Container(),
        // ignore: unnecessary_null_comparison
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
