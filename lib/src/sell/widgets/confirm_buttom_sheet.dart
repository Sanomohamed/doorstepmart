import 'package:flutter/material.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  
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
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel),
                label: const Text("Cancel"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              ),
              ElevatedButton.icon(
                onPressed: () {
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
