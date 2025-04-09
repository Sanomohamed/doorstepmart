import 'package:flutter/material.dart';
//importing the necessary package for the time picker tile widget

class TimePickerTile extends StatelessWidget {
  // This widget is a custom tile for selecting time in a time picker dialog.
  final String label;
  // The label to be displayed on the tile
  final TimeOfDay? time;
  // The selected time, which can be null if not selected
  // The time picker tile widget is used to display the selected time and trigger the time picker dialog when tapped.
  final VoidCallback onTap;
  // Callback function to be executed when the tile is tapped

  const TimePickerTile({
    super.key,
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Building the widget tree for the TimePickerTile
    return ListTile(
      // Creating a ListTile widget to display the time picker tile
      minVerticalPadding: 15, // Increase vertical spacing
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // More padding
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: const Color.fromARGB(255, 167, 175, 162)),
      ),
      title: Text(
        // Displaying the label and selected time
        // If time is null, display "Not selected" message
        time == null ? "$label: Not selected" : "$label: ${time?.format(context)}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.access_time),
      onTap: onTap,
      // Trigger the time picker dialog when the tile is tapped
    );
  }
}
