import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/favorite/widgets/favorite_card.dart';
import 'package:doorstepmart/src/favorite/widgets/favorite_empty_state.dart';
import 'package:doorstepmart/src/favorite/favoritemodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final Map<String, String> _shopNamesCache = {};

  @override
  void initState() {
    super.initState();
    Provider.of<FavoriteModel>(context, listen: false).loadFavorites();
  }

  Future<String> _fetchShopName(String shopId) async {
    if (_shopNamesCache.containsKey(shopId)) return _shopNamesCache[shopId]!;

    try {
      DocumentSnapshot shopDoc = await FirebaseFirestore.instance.collection('shops').doc(shopId).get();
      if (shopDoc.exists) {
        String shopName = shopDoc['name'] ?? "Unknown Shop";
        _shopNamesCache[shopId] = shopName;
        return shopName;
      }
    } catch (e) {
      debugPrint("🔥 Error fetching shop name: $e");
    }
    return "Unknown Shop";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color.fromARGB(248, 237, 245, 236),
      body: Consumer<FavoriteModel>(
        builder: (context, favoriteModel, child) {
          if (favoriteModel.favorites.isEmpty) {
            return const FavoriteEmptyState();
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: favoriteModel.favorites.length,
                  itemBuilder: (context, index) {
                    final product = favoriteModel.favorites[index];
                    return FavoriteCard(product: product);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}