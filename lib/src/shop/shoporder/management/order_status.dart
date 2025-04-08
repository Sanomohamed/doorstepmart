import 'package:flutter/material.dart';

class OrderStatusDropdown extends StatelessWidget {
  final String currentStatus;
  final Function(String) onChanged;

  const OrderStatusDropdown({
    super.key,
    required this.currentStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentStatus,
      isExpanded: true,
      items: const [
        DropdownMenuItem(value: 'Pending', child: Text('Pending', style: TextStyle(fontSize: 20))),
        DropdownMenuItem(value: 'Processing', child: Text('Processing',style: TextStyle(fontSize: 20))),
        DropdownMenuItem(value: 'Confirmed', child: Text('Confirmed', style: TextStyle(fontSize: 20))),
        DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled', style: TextStyle(fontSize: 20))),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
