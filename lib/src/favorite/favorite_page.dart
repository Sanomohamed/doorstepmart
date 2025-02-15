import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
       return Scaffold(

      appBar: AppBar(
        title: Text('My Favorites'),
        backgroundColor: const Color.fromARGB(255, 137, 185, 138),
      ),

      backgroundColor: const Color.fromARGB(255, 137, 185, 138),
      body: Consumer<FavoriteModel>(
        builder: (context, favoriteModel, child) {
            return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
             child: GridView.builder(
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                mainAxisSpacing: 0,
                childAspectRatio: 0.95,
              ),
              itemCount: favoriteModel.favorites.length,
              itemBuilder: (context, index) {
                final product = favoriteModel.favorites[index];
                return Stack(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                                color: Colors.grey[300],
                              ),
                              child: Image.asset(
                                product.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 14, 13, 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      right: 15,
                      child: CircleAvatar(
                        child: IconButton(
                          icon: const Icon(Icons.add, size: 27, color: Colors.black),
                          onPressed: () {
                            Provider.of<CartModel>(context, listen: false).add(
                              CartItem(
                                name: product.name,
                                image: product.image,
                                price: product.price,
                                quantity: 1,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}