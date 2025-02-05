// ignore: file_names
import 'package:flutter/material.dart';

class ActivitySection extends StatelessWidget {
  
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'More Activity',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('My Favorite'),
          onTap: () {
            // Handle my favorite action
          },
        ),
        ListTile(
          leading: const Icon(Icons.remove_red_eye),
          title: const Text('Recently Viewed'),
          onTap: () {
            // Handle recently viewed action
          },
        ),
      ],
    );
  }
}