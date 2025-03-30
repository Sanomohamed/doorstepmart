import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;

  const ProductImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
        width: double.infinity,
        height: 420,
        fit: BoxFit.cover,
      ),
    );
  }
}
