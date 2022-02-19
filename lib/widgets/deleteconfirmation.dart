import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

import 'custom_alert.dart';

void deleteConfirmationDialog(BuildContext context, Function yesPressed, Function noPressed) {
  var dialog = CustomAlertDialog(
      title: 'Delete',
      message: 'Are you sure you want to delete?',
      positiveBtnText: 'Yes',
      negativeBtnText: 'No',
      onPostivePressed: () => yesPressed(),
      onNegativePressed: () => noPressed());
  showDialog(context: context, builder: (BuildContext context) => dialog);
}
