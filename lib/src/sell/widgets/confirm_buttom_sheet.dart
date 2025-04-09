import 'package:flutter/material.dart';
//importing the necessary package and files for the confirmation bottom sheet

class ConfirmationBottomSheet extends StatelessWidget {
  // This widget is used to show a confirmation bottom sheet with a title, a confirm label, and a callback function.
  // It is used to confirm actions such as deleting a product or confirming an action.
  final String title;
  final String confirmLabel;
  final VoidCallback onConfirm;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.confirmLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding widget is used to add padding around the confirmation bottom sheet
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                // ElevatedButton is used to create a button with an icon and text
                // The icon is displayed on the left side of the button
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel),
                label: const Text("Cancel"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // When the confirm button is pressed, it will call the onConfirm callback function and close the bottom sheet
                  // This is where the action will be confirmed, such as uploading a product
                  Navigator.pop(context);
                  onConfirm();
                },
                icon: const Icon(Icons.check),
                label: Text(confirmLabel),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          )
        ],
      ),
    );
  }
}
