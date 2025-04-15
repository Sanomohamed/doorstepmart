// ignore_for_file: use_build_context_synchronously
import 'package:doorstepmart/src/profile/widgets/profile_update_dialog.dart';    
import 'package:flutter/material.dart';                            //importing the necessary packages and files
import 'package:doorstepmart/src/sell/product_action.dart';

class ConfirmUploadActions extends StatelessWidget {

  final GlobalKey<FormState> formKey;  // A key to identify the form and validate its state.
 
  final bool isUploading;
 
  final String? productId;
  
  final Map<String, dynamic> Function() getProductData; // dynamic data fetch
 
  final VoidCallback onUploadStart;
  final VoidCallback onUploadEnd;

  const ConfirmUploadActions({
    super.key,
    required this.formKey,
    required this.isUploading,
    required this.productId,
    required this.getProductData,
    required this.onUploadStart,
    required this.onUploadEnd,
  });

  void _showConfirmationBottomSheet(BuildContext context) {
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              productId == null ? "Upload this product?" : "Update this product?",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _startUpload(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Yes, Proceed"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _startUpload(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 300));

    late BuildContext dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return const UploadProgressDialog();
      },
    );

    await ProductActions.upload(
      context: context,
      formKey: formKey,
      isUploading: isUploading,
      productId: productId,
      productData: getProductData(), // Always fetch latest values
      onUploadStart: onUploadStart,
      onUploadEnd: () {
        Navigator.of(dialogContext).pop(); // Close upload dialog
        onUploadEnd();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showConfirmationBottomSheet(context),
      icon: Icon(productId == null ? Icons.cloud_upload : Icons.edit),
      label: Text(productId == null ? "Upload Product" : "Update Product"),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    );
  }
}
