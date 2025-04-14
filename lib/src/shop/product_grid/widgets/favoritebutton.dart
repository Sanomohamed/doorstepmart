import 'package:doorstepmart/src/favorite/favoritemodel.dart';    //importing the necessary packages and files
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  
  final Map<String, dynamic> product;
  const FavoriteButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
   
    final favoriteModel = Provider.of<FavoriteModel>(context);
    final String name = product['name'] ?? '';
    final bool isFavorite = favoriteModel.isFavorite(name);

    return IconButton(
      icon: Icon( // An IconButton that toggles the favorite status of the item.
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
        size: 26,
      ),
 // When the button is pressed, it toggles the favorite status of the item.      
      onPressed: () {
        if (!isFavorite) {
          favoriteModel.add(FavoriteItem(
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
