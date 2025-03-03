import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeverageSection extends StatelessWidget {
  const BeverageSection({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> products = [
      {
        'name': 'Coca Cola',
        'image': 'assets/image.png',
        'price': 3.50,
      },
      {
        'name': 'Pepsi',
        'image': 'assets/image.png',
        'price': 3.00,
      },
      {
        'name': 'Sprite',
        'image': 'assets/image.png',
        'price': 2.50,
      },
      {
        'name': 'Fanta',
        'image': 'assets/image.png',
        'price': 3.20,
      },
      {
        'name': 'Mountain Dew',
        'image': 'assets/image.png',
        'price': 3.10,
      },
      {
        'name': 'Dr Pepper',
        'image': 'assets/image.png',
        'price': 3.40,
      },
      {
        'name': '7 Up',
        'image': 'assets/image.png',
        'price': 2.80,
      },
      {
        'name': 'Mirinda',
        'image': 'assets/image.png',
        'price': 3.00,
      },
      {
        'name': 'Red Bull',
        'image': 'assets/image.png',
        'price': 4.00,
      },
      {
        'name': 'Monster',
        'image': 'assets/image.png',
        'price': 4.50,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
         color: Color.fromARGB(211, 255, 255, 255),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Beverage',
                style: TextStyle(
                  fontSize: 20,
                   fontWeight: FontWeight.bold,
                   color: Colors.black87),
              ),
              GestureDetector(
                onTap: () {
                  // Add action for "See More"
                },
                child: Row(
                  children: const [
                    Text(
                      'View more',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 270, 
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length, // Add more items if needed
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemBuilder: (context, index) {
                final product = products[index];

                return Column(
                  children: [
                    Container(
                      width: 150,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                            'assets/image.png',// Replace with your image/icon
                            fit: BoxFit.cover,
                     ),
                    ),
                    const SizedBox(height: 8),

                     Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                     Text(
                      'RM${product['price']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                       Provider.of<CartModel>(context, listen: false).add(
                          CartItem(
                            name: product['name'],
                            image: product['image'],
                            price: product['price'],
                            quantity: 1,
                          ),
                        );
                        // Add action for adding to cart
                         ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product['name']} added to cart'),
                                      duration: const Duration(milliseconds: 700),
                                    ),
                                  );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
