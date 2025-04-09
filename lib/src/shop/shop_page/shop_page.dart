import 'package:doorstepmart/src/shop/shop_page/shop_product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//importing the necessary packages and files for the ShopPage widget

class ShopPage extends StatelessWidget {
  //creating a stateless widget for the ShopPage
  final String shopId;
  //defining the shopId as a final variable

  const ShopPage({super.key, required this.shopId});

  Future<String> _fetchShopName() async {
    //fetching the shop name from Firestore using the shopId
    final doc = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
    return doc.data()?['shopName'] ?? 'Shop';
  }

  @override
  Widget build(BuildContext context) {
    //building the widget
    //using MediaQuery to get the screen width and determine the number of columns for the grid
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = screenWidth > 1000 ? 4 : screenWidth > 600 ? 3 : 2;

    return Scaffold(
      //creating a scaffold widget for the ShopPage
      appBar: AppBar(
        title: FutureBuilder<String>(
          //using FutureBuilder to fetch the shop name asynchronously
          //and display it in the app bar
          future: _fetchShopName(),
          builder: (context, snapshot) => Text(snapshot.data ?? 'Shop'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        //using StreamBuilder to listen for changes in the Firestore collection
        //and update the UI accordingly
        stream: FirebaseFirestore.instance
           //selecting the 'products' collection from Firestore
            //and filtering the documents based on the shopId
            .collection('products')
            .where('shopId', isEqualTo: shopId)
            .snapshots(),
        builder: (context, snapshot) {
          //building the UI based on the snapshot data
          if (snapshot.connectionState == ConnectionState.waiting) {
            //showing a loading indicator while waiting for data
            //if the connection state is waiting
            return const Center(child: CircularProgressIndicator());

          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            //checking if there is no data or if the documents are empty
            //and showing a message if there are no products found for the shop
            return const Center(child: Text("No products found for this shop."));
          }
          final products = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          //mapping the documents to a list of products
          //using the map function to convert each document to a Map<String, dynamic>

          return Center(
            //creating a center widget to center the content
            //inside the body of the scaffold
            child: ConstrainedBox(
              //using ConstrainedBox to set the maximum width of the grid
              constraints: const BoxConstraints(maxWidth: 1200),
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  //building the grid items using GridView.builder
                  //using the itemBuilder to create each grid item
                  return ShopProductCard(product: products[index]);
                  //returning the ShopProductCard widget for each product
                  //passing the product data to the ShopProductCard widget
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
