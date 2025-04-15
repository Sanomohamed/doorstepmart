import 'package:flutter/material.dart';

void showUploadProgressDialog(BuildContext context) {
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
  const UploadProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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