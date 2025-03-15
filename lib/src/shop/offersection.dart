import 'package:flutter/material.dart';

class OfferSection extends StatelessWidget {
  const OfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.local_offer, color: Colors.red),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Limited Time Offer!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Get 10% off on all products - Use code: SAVE10',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {
              // Action for the button
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 212, 95, 86),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Shop Now'),
          ),
        ],
      ),
    );
  }
}