import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
//importing the necessary packages and files 

class DeleteButton extends StatelessWidget {

  final String productId;


  const DeleteButton({super.key, required this.productId});

  Future<void> _handleDelete(BuildContext context) async {
    // Show a confirmation dialog before deleting the product
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();
    // Delete the product from Firestore
    // Show a success message using Fluttertoast
    Fluttertoast.showToast(msg: "Product deleted successfully");
    if (context.mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    // Build the delete button with an icon and label
    return ElevatedButton.icon(
      // When the button is pressed, it will call the _handleDelete method
      // This method will delete the product from Firestore and show a success message
      onPressed: () => _handleDelete(context),
      icon: const Icon(Icons.delete),
      label: const Text("Delete Product"),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    );
  }
}
