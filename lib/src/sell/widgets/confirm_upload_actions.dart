import 'package:doorstepmart/src/profile/widgets/profile_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/sell/product_action.dart';
//importing the necessary packages and files

class ConfirmUploadActions extends StatelessWidget {
  /// A widget that provides a button to confirm the upload of a product.
  /// It shows a confirmation dialog and handles the upload process.
  final GlobalKey<FormState> formKey;
  /// A key to identify the form and validate its state.
  final bool isUploading;
  /// A boolean value indicating whether the upload is in progress.
  final String? productId;
  /// The ID of the product being uploaded. If null, it indicates a new product upload.
  final Map<String, dynamic> Function() getProductData; // dynamic data fetch
  /// A function that returns the product data to be uploaded.
  /// It is called to fetch the latest values before uploading.
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
    /// Shows a confirmation bottom sheet to confirm the upload of a product.
    /// It displays a title, a cancel button, and a confirm button.
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        // Padding widget is used to add padding around the confirmation bottom sheet
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              productId == null ? "Upload this product?" : "Update this product?",
              // Title of the confirmation dialog
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  // ElevatedButton is used to create a button with an icon and text
                  // The icon is displayed on the left side of the button
                  onPressed: () => Navigator.pop(context),
                  // When the cancel button is pressed, it will close the bottom sheet
                  // This is where the action will be cancelled, such as uploading a product
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // When the confirm button is pressed, it will close the bottom sheet and start the upload process
                    // This is where the action will be confirmed, such as uploading a product
                    Navigator.pop(context);
                    _startUpload(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Yes, Proceed"),
                  // The label of the button indicates the action being confirmed
                  // In this case, it is confirming the upload of the product
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
    /// Starts the upload process for the product.
    /// It shows a loading dialog and calls the upload function from ProductActions.
    await Future.delayed(const Duration(milliseconds: 300));

    late BuildContext dialogContext;
    // Show a loading dialog while the upload is in progress
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return const UploadProgressDialog();
      },
    );

    await ProductActions.upload(
      // Call the upload function from ProductActions to upload the product
      // Pass the necessary parameters such as context, formKey, isUploading, productId, and productData
      // ignore: use_build_context_synchronously
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
    /// Builds the ConfirmUploadActions widget.
    /// It returns an ElevatedButton with an icon and a label.
    return ElevatedButton.icon(
      onPressed: () => _showConfirmationBottomSheet(context),
      // When the button is pressed, it will show the confirmation bottom sheet
      // This is where the action will be confirmed, such as uploading a product
      icon: Icon(productId == null ? Icons.cloud_upload : Icons.edit),
      label: Text(productId == null ? "Upload Product" : "Update Product"),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    );
  }
}
