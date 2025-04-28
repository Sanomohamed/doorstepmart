import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/shop_page/shop_product_card.dart';

class ProductSearchDelegate extends SearchDelegate<void> {
  @override
  String get searchFieldLabel => 'Search products…';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  // Optional: show recent searches or nothing
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Start typing to search'));
    }
    // Simply forward to the same results UI
    return buildResults(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    // Firestore prefix query
    final stream = FirebaseFirestore.instance
      .collection('products')
      .where('name', isGreaterThanOrEqualTo: query)
      .where('name', isLessThanOrEqualTo: query + '\uf8ff')
      .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return Center(child: Text('No results for “$query”'));
        }
        final docs = snap.data!.docs;
        final products = docs
            .map((d) => d.data() as Map<String, dynamic>)
            .toList();

        // Responsive grid, matching your ShopPage style
        final width = MediaQuery.of(context).size.width;
        final columns = width > 1000 ? 4 : width > 600 ? 3 : 2;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (ctx, i) {
                  return ShopProductCard(product: products[i]);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
