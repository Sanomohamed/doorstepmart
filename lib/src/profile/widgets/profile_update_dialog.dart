import 'package:flutter/material.dart';
//importing the necessary packages

void showUploadProgressDialog(BuildContext context) {
  //showing a dialog with a progress indicator
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Saving changes..."),
          ],
        ),
      );
    },
  );
}

class UploadProgressDialog extends StatelessWidget {
  // A stateless widget that shows a progress dialog
  // when the user is uploading a profile picture.
  const UploadProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // A dialog that shows a progress indicator and a message
      backgroundColor: Colors.white,
      content: Row(
        children: const [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text("Uploading..."),
        ],
      ),
    );
  }
}