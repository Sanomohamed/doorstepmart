import 'package:flutter/material.dart';
//importing the necessary packages for the snackbar

void showConfirmationSnackbar({
  // Function to show a confirmation snackbar
  // This function takes a BuildContext and a callback function to be executed on confirmation
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
