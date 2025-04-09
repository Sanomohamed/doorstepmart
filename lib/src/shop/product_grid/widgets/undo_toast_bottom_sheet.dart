import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
//importing the necessary packages

void showUndoToastBottomSheet({
  //function to show a bottom sheet with an undo option
  required BuildContext context,
  required CartItem addedItem,
  required VoidCallback onUndo,
}) {
  showModalBottomSheet(
    //showing a modal bottom sheet
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (BuildContext modalContext) {
      //creating a modal context for the bottom sheet
      //using Future.delayed to automatically close the bottom sheet after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        // ignore: use_build_context_synchronously
        if (Navigator.of(modalContext).canPop()) {
          // ignore: use_build_context_synchronously
          Navigator.of(modalContext).pop();
        }
      });

      return Padding(
        //adding padding to the bottom sheet

        padding: const EdgeInsets.only(bottom: 60, left: 16, right: 16),
        child: Material(
          //using Material widget to create a material design bottom sheet
          borderRadius: BorderRadius.circular(12),
          color: Colors.black87,
          child: Padding(
            //adding padding to the content of the bottom sheet
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              //creating a row to display the content of the bottom sheet
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${addedItem.name} added to cart',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  //creating a text button for the undo action
                  onPressed: () {
                    //when the button is pressed, it calls the onUndo function and closes the bottom sheet
                    onUndo();
                    Navigator.of(modalContext).pop();
                  },
                  child: const Text('UNDO', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
