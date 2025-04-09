import 'package:flutter/material.dart';
//importing the necessary packages for the widget

void showConfirmationSnackbar({
  //creating a function to show a confirmation snackbar
  required BuildContext context,
  //the context of the widget
  required String message,
  //the message to be displayed in the snackbar
  required VoidCallback onConfirmed,
  //the function to be called when the user confirms the action
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    //showing the snackbar using the ScaffoldMessenger
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
  //creating a function to show a confirmation bottom sheet for deletion
  required BuildContext context,
  required VoidCallback onConfirmed,
}) {
  return showModalBottomSheet(
    //showing the bottom sheet using the showModalBottomSheet function
    context: context,
    backgroundColor: const Color.fromARGB(255, 121, 118, 118),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Padding(
      //adding padding to the bottom sheet
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //adding a title to the bottom sheet
          const Text("Delete this product?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                //creating a button to cancel the deletion
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel, color: Colors.green),
                label: const Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 18)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(232, 212, 218, 209)),
              ),
              ElevatedButton.icon(
                //creating a button to confirm the deletion
                //when pressed, it will call the onConfirmed function and close the bottom sheet
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

