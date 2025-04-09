import 'package:flutter/material.dart';
//importing the necessary packages for the submit button widget

class SubmitButton extends StatelessWidget {
  // Defining the properties of the SubmitButton widget
  final VoidCallback onPressed;
  // Callback function to be executed when the button is pressed
  final bool isLoading;
  // Boolean to indicate if the button is in loading state
  final String label;
  // Default label for the button, set to 'Create'

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    this.label = ' Create ',
  });

  @override
  Widget build(BuildContext context) {
    // Building the widget tree for the SubmitButton
    return ElevatedButton(
      // Creating an ElevatedButton widget
      onPressed: isLoading ? null : onPressed,
      // Disabling the button if isLoading is true
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 6,
      ),
      child: isLoading
        // If isLoading is true, show a loading indicator
        // Otherwise, show the button label
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
