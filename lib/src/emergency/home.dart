import 'package:doorstepmart/src/home/beverage.dart';
import 'package:doorstepmart/src/shop/productgrid.dart';
import 'package:doorstepmart/src/shop/shop.dart';
import 'package:doorstepmart/src/cart/shop_cart.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  const Home({super.key});

  @override
  Widget build(BuildContext context){
     final List<Map<String, dynamic>> products = [
      {'name': 'Coca Cola', 'image': 'assets/image.png', 'price': 3.50},
      {'name': 'Pepsi', 'image': 'assets/image.png', 'price': 3.00},
      {'name': 'drink', 'image': 'assets/image.png', 'price': 3.10},
      {'name': 'vegetable', 'image': 'assets/image.png', 'price': 3.20},
      {'name': 'fruit', 'image': 'assets/image.png', 'price': 3.30},
      {'name': 'apple', 'image': 'assets/image.png', 'price': 3.40},
      {'name': 'banana', 'image': 'assets/image.png', 'price': 3.45},
      {'name': 'vegetables', 'image': 'assets/image.png', 'price': 3.20},
      {'name': 'fruits', 'image': 'assets/image.png', 'price': 3.30},
      {'name': 'apples', 'image': 'assets/image.png', 'price': 3.40},
      {'name': 'bananas', 'image': 'assets/image.png', 'price': 3.45},
      {'name': 'redbull', 'image': 'assets/image.png', 'price': 4.45},
      {'name': 'meat', 'image': 'assets/image.png', 'price': 2.20},
      {'name': 'rice', 'image': 'assets/image.png', 'price': 1.30},
      {'name': 'drink', 'image': 'assets/image.png', 'price': 2.40},
      {'name': 'ananas', 'image': 'assets/image.png', 'price': 6.45},
      // Add more products here
    ];
    return Scaffold(
       backgroundColor: Color(0xFFD2DBD6),
      body: Align(
        //alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: 500,
                  height: 200, // Increased height to accommodate both rows
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2DBD6),
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage('assets/image.png'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                // ignore: deprecated_member_use
                               // color: Colors.white.withOpacity(0.5),
                                children: [
                                  Icon(Icons.search, size: 40),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite, size: 40,color: Colors.green),
                            onPressed: () {},
                          ),
                          //IconButton(
                          //  icon: Icon(Icons.thumb_up, size: 40),
                          //  onPressed: () {},
                         // ),
                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ))
                  ],
                ),
                SizedBox(height: 8.0),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 26, 
                            fontWeight: FontWeight.bold
                            ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) => MiniMartPage(),
                            )
                            );
                            // Navigate to the See More page
                          },
                          child: Row(
                            children: [
                              Text('See more', 
                              style: TextStyle(
                              color: Colors.black)),
                              Icon(
                              Icons.arrow_forward, 
                              size: 16, 
                              color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 5),
                    SizedBox(
                    height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10, // Number of products
                        separatorBuilder: (_, __) => SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          // Use different icons for the ProductCard
                          IconData icon = Icons.local_offer; // Default icon
                          if (index == 0) icon = Icons.local_grocery_store;
                          if (index == 1) icon = Icons.eco;
                          return ProductCard(
                            icon: icon,
                            name: 'shop $index',
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
               // PromotionSection(),
                BeverageSection(),
                SizedBox(height: 8),
                ProductGrid(products: products),
              ],
            ),
          ),
        )
      ),
    );
  } 
}