import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings, size: 28, color: Colors.black54),
      onPressed: () {
        // Future implementation of settings page
      },
    );
  }
}
