import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/headeersection.dart';
import 'package:doorstepmart/src/shop/offersection.dart';
import 'package:doorstepmart/src/shop/productgrid.dart';
import 'package:flutter/material.dart';

class MiniMartPage extends StatefulWidget {
  const MiniMartPage({super.key});

  @override
  _MiniMartPageState createState() => _MiniMartPageState();
}

class _MiniMartPageState extends State<MiniMartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('products').get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error loading products"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No products available"));
                }
                
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const OfferSection(),
                        const SizedBox(height: 10),
                        ProductGrid(products: snapshot.data!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}