import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//importing the necessary packages and files for the FavoriteButton widget

class FavoriteButton extends StatelessWidget {
  /// A button that allows users to add or remove items from their favorites.
  /// It displays a heart icon that changes based on the favorite status of the item.
  final Map<String, dynamic> product;
  const FavoriteButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    /// Builds the FavoriteButton widget.
    /// Uses the Provider package to access the FavoriteModel.
    final favoriteModel = Provider.of<FavoriteModel>(context);
    final String name = product['name'] ?? '';
    final bool isFavorite = favoriteModel.isFavorite(name);

    return IconButton(
      /// An IconButton that toggles the favorite status of the item.
      icon: Icon(
        /// Displays a heart icon that changes based on the favorite status of the item.
        /// If the item is a favorite, it shows a filled heart icon, otherwise it shows an outlined heart icon.
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
        size: 26,
      ),
      onPressed: () {
        /// When the button is pressed, it toggles the favorite status of the item.
        if (!isFavorite) {
          /// If the item is not a favorite, it adds it to the favorites list.
          /// It also shows a snackbar with a message indicating that the item has been added to favorites.
          favoriteModel.add(FavoriteItem(
            /// Creating a FavoriteItem object with the product details
            name: name,
            image: (product['imageUrls'] as List?)?.first ?? '',
            price: (product['price'] as num?)?.toDouble() ?? 0.0,
            shopId: product['shopId'] ?? '',
            shopName: product['shopName'] ?? '',
          ));
          _showSnackbar(context, '$name added to favorites');
        } else {
          favoriteModel.remove(name);
          _showSnackbar(context, '$name removed from favorites');
        }
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 1000)),
    );
  }
}
