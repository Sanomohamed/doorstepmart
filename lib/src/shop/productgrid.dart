import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductGrid({super.key, required this.products});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 20,
          childAspectRatio: 0.95,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
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
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              color: Colors.grey[300],
                            ),
                            child: Image.asset(
                              product['image'], // Replace with your image/icon
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              child:Center(
                              child: IconButton(
                                icon: const Icon(Icons.add, size: 25, color: Color.fromARGB(255, 255, 255, 255)),
                                onPressed: () {
                                  Provider.of<CartModel>(context, listen: false).add(
                                    CartItem(
                                      name: product['name'],
                                      image: product['image'],
                                      price: product['price'],
                                      quantity: 1,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product['name']} added to cart'),
                                      duration: const Duration(milliseconds: 100),
                                    ),
                                  );
                                },
                              ),
                              ),
                            ),
                          ),

                          Positioned(
                          bottom: 10,
                          left: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child:Center(
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border, size: 25, color: Color.fromARGB(255, 252, 252, 252)),
                               onPressed: () {
                                  final favoriteModel = Provider.of<FavoriteModel>(context, listen: false);
                                  final isAlreadyFavorite = favoriteModel.favorites.any((item) => item.name == product['name']);

                                  if (!isAlreadyFavorite) {
                                    favoriteModel.add(
                                      FavoriteItem(
                                        name: product['name'],
                                        image: product['image'],
                                        price: product['price'],
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product['name']} added to favorites'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product['name']} is already in favorites'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                            ),
                            )
                          ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            product['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'RM${product['price']}',
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
            ],
          );
        },
      ),
    );
  }
}