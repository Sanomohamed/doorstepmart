import 'package:flutter/material.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ListTile(
          leading: const Icon(Icons.help_center),
          title: const Text('Help Center'),
          onTap: () {
            // Handle help center action
          },
        ),
        ListTile(
          leading: const Icon(Icons.chat),
          title: const Text('Chat with AI'),
          onTap: () {
            // Handle chat with AI action
          },
        ),
      ],
    );
  }
}