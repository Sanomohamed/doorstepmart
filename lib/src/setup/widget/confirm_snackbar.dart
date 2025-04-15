import 'package:flutter/material.dart';

void showConfirmationSnackbar({
  required BuildContext context,
  required String message,
  required VoidCallback onConfirmed,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Yes',
        onPressed: onConfirmed,
      ),
      duration: const Duration(seconds: 4),
    ),
  );
}

Future<void> showDeleteConfirmationBottomSheet({
  required BuildContext context,
  required VoidCallback onConfirmed,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: const Color.fromARGB(255, 121, 118, 118),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Delete this product?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel, color: Colors.green),
                label: const Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 18)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(232, 212, 218, 209)),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirmed();
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text("Yes, Delete", style: TextStyle(color: Colors.black, fontSize: 18)),
                style: ElevatedButton.styleFrom(backgroundColor:  const Color.fromARGB(232, 212, 218, 209)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

