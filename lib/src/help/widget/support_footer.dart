import 'package:flutter/material.dart';

class SupportFooter extends StatelessWidget {
  const SupportFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Need more help? Contact support@doorstepmart.app',
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        textAlign: TextAlign.center,
      ),
    );
  }
}
