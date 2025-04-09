import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//importing the necessary packages for the image section

class ProductImageSection extends StatelessWidget {
  // Defining a stateless widget for the product image section
  final String imageUrl;
  // A final variable to hold the image URL

  const ProductImageSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        // Using ClipRRect to round the corners of the image
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: CachedNetworkImage(
          // Using CachedNetworkImage to load the image from the network
          // This widget caches the image for better performance
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          // Placeholder while the image is loading
          errorWidget: (context, url, error) =>
              Image.network('https://via.placeholder.com/150', fit: BoxFit.cover),
          // Error widget if the image fails to load
        ),
      ),
    );
  }
}
