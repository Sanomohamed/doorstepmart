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
        title: Text('Favorites'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 237, 252, 237),
      body: Consumer<FavoriteModel>(
        builder: (context, favoriteModel, child) {
            return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
                                  '\RM${product.price}',
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
                      bottom: 40,
                      right: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        child:Center(
                        child: IconButton(
                          icon: const Icon(Icons.add, size: 25, color: Color.fromARGB(255, 252, 252, 252)),
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
                                duration: const Duration(milliseconds: 100),
                              ),
                            );
                          },
                        ),
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