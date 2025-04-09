import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.only(top: 125),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85), // More solid white for better contrast
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 24, color: Colors.black87), // Darker icon
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.black87), // Visible typed text
              decoration: const InputDecoration(
                hintText: 'Search for products...',
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                // TODO: Implement search
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic, size: 24, color: Colors.black87), // Darker mic
            onPressed: () {
              // TODO: Implement voice search
            },
          ),
        ],
      ),
    );
  }
}
