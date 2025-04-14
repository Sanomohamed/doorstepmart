import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';   //importing the necessary packages and files 
import 'package:fluttertoast/fluttertoast.dart';

class DeleteButton extends StatelessWidget {

  final String productId;

  const DeleteButton({super.key, required this.productId});

  Future<void> _handleDelete(BuildContext context) async {
   
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();
    Fluttertoast.showToast(msg: "Product deleted successfully");
    if (context.mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _handleDelete(context),
      icon: const Icon(Icons.delete),
      label: const Text("Delete Product"),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    );
  }
}
