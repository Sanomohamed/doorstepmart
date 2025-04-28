// home_header.dart
import 'dart:async';

import 'package:doorstepmart/src/home/categories/categories_section.dart';
import 'package:doorstepmart/src/search/productsearchdelegate.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/favorite/favorite_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  late Future<List<String>> _adsFuture;
  List<String>? _adsFutureData;

  @override
  void initState() {
    super.initState();
    _adsFuture = _loadAdUrls();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_pageController.hasClients && _adsFutureData != null) {
        _currentPage = (_currentPage + 1) % _adsFutureData!.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<List<String>> _loadAdUrls() async {
    final ref = FirebaseStorage.instance.ref('ads');
    final list = await ref.listAll();
    final urls = await Future.wait(list.items.map((f) => f.getDownloadURL()));
    _adsFutureData = urls;
    return urls;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        children: [
          // ─── Ad Carousel ───
          FutureBuilder<List<String>>(
            future: _adsFuture,
            builder: (ctx, snap) {
              if (!snap.hasData) {
                return Container(color: Colors.grey[200]);
              }
              final ads = snap.data!;
              return PageView.builder(
                controller: _pageController,
                itemCount: ads.length,
                onPageChanged: (i) => _currentPage = i,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CategoriesSection(),
                      ),
                    );
                  },
                  child: Image.network(
                    ads[i],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),

          // ─── Top Menu & Favorite ───
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu,
                      color: Color.fromARGB(255, 39, 39, 39), size: 28),
                  onPressed: () {
                    // open your drawer or menu
                  },
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.heart,
                      color: Color.fromARGB(255, 20, 20, 20), size: 26),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritePage()),
                  ),
                ),
              ],
            ),
          ),

          // ─── Overlay Search Bar ───
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.white.withOpacity(0.9),
              elevation: 4,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                readOnly: true,           // ← no direct typing here
                onTap: () => showSearch(
                  context: context,
                  delegate: ProductSearchDelegate(),
                ),
                decoration: InputDecoration(
                  hintText: 'Search for products...',
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.grey),
                    onPressed: () {
                      // voice search
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
