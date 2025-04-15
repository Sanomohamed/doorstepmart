import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String content;
  const InfoCard(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0), 
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            content,
            style: const TextStyle(fontSize: 22, height: 1.6),
          ),
        ),
      ),
    );
  }
}
