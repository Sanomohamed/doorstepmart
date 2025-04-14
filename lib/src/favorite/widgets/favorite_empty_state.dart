import 'package:flutter/material.dart';

class FavoriteEmptyState extends StatelessWidget {
  const FavoriteEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "No favorite items found!",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }
}