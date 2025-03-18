import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/shop/headeersection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/productgrid.dart';

class MiniMartPage extends StatefulWidget {
  const MiniMartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MiniMartPageState createState() => _MiniMartPageState();
}

class _MiniMartPageState extends State<MiniMartPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // ✅ Keeps MiniMart state when navigating back

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ Ensures state persistence

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                try {
                  await Provider.of<ProductProvider>(context, listen: false).fetchProducts(forceRefresh: true);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error refreshing products: $e")),
                  );
                }
              },
              child: Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  return provider.isLoading
                      ? const Center(child: CircularProgressIndicator()) // ✅ Handles Loading State
                      : const ProductGrid(); // ✅ Uses Cached Products If Available
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
