import 'package:doorstepmart/src/profile/widgets/profile_update_dialog.dart';
import 'package:doorstepmart/src/sell/widgets/confirm_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/sell/product_action.dart';
//import 'package:doorstepmart/widgets/bottomsheets/confirmation_bottom_sheet.dart';
//import 'package:doorstepmart/widgets/dialogs/upload_progress_dialog.dart';

class ConfirmUploadActions extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isUploading;
  final String? productId;
  final Map<String, dynamic> productData;
  final VoidCallback onUploadStart;
  final VoidCallback onUploadEnd;

  const ConfirmUploadActions({
    super.key,
    required this.formKey,
    required this.isUploading,
    required this.productId,
    required this.productData,
    required this.onUploadStart,
    required this.onUploadEnd,
  });

  void _showUploadConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ConfirmationBottomSheet(
        title: productId == null ? "Upload this product?" : "Update this product?",
        confirmLabel: "Yes, Proceed",
        onConfirm: () => _startUpload(context),
      ),
    );
  }

  void _startUpload(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const UploadProgressDialog(),
    );

    await ProductActions.upload(
      context: context,
      formKey: formKey,
      isUploading: isUploading,
      productId: productId,
      productData: productData,
      onUploadStart: onUploadStart,
      onUploadEnd: () {
        if (Navigator.canPop(context)) Navigator.of(context).pop(); // Close dialog
        onUploadEnd();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showUploadConfirmation(context),
      icon: Icon(productId == null ? Icons.cloud_upload : Icons.edit),
      label: Text(productId == null ? "Upload Product" : "Update Product"),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
    );
  }
}
