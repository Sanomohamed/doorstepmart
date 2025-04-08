import 'package:flutter/material.dart';

class TimePickerTile extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const TimePickerTile({
    super.key,
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 15, // Increase vertical spacing
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // More padding
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: const Color.fromARGB(255, 167, 175, 162)),
      ),
      title: Text(
        time == null ? "$label: Not selected" : "$label: ${time?.format(context)}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.access_time),
      onTap: onTap,
    );
  }
}
