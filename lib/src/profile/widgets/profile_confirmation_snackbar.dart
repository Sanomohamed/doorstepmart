import 'package:flutter/material.dart';

void showConfirmationSnackbar({
  required BuildContext context,
  required VoidCallback onConfirmed,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Are you sure you want to update your profile?'),
      action: SnackBarAction(
        label: 'OK',
        onPressed: onConfirmed,
      ),
    ),
  );
}
