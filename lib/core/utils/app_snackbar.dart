import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SnackType { success, error, info }

void showAppSnackBar(
  BuildContext context, {
  required String message,
  required SnackType type,
}) {
  final overlay = Overlay.of(context);

  switch (type) {
    case SnackType.success:
      showTopSnackBar(overlay, CustomSnackBar.success(message: message));
      break;

    case SnackType.error:
      showTopSnackBar(overlay, CustomSnackBar.error(message: message));
      break;

    case SnackType.info:
      showTopSnackBar(overlay, CustomSnackBar.info(message: message));
      break;
  }
}
