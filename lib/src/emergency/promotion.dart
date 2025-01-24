import 'dart:async';

import 'package:flutter/material.dart';

class PromotionSection extends StatefulWidget {
  const PromotionSection({super.key});

  @override
  State<PromotionSection> createState() => _PromotionSectionState();
}

class _PromotionSectionState extends State<PromotionSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of icons for the promotion
  final List<IconData> _promotionalIcons = [
    Icons.local_offer,
    Icons.free_breakfast,
    Icons.card_giftcard,
    Icons.star,
    Icons.delivery_dining,
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (_currentPage < _promotionalIcons.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 78, 211, 138),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promotion',
            style: TextStyle(
            fontSize: 1, 
            fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _promotionalIcons.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _promotionalIcons[index],
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'FREE SHIPPING',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
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
