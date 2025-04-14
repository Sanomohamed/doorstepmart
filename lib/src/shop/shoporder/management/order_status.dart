import 'package:flutter/material.dart';

class OrderStatusDropdown extends StatelessWidget {
  final String currentStatus;        //defining the current status of the order
  final Function(String) onChanged; //defining a function that will be called when the status is changed

  const OrderStatusDropdown({
    super.key,
    required this.currentStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
//creating a dropdown button with a string value    
    return DropdownButton<String>(
      value: currentStatus,
      isExpanded: true,
//defining the items in the dropdown menu      
      items: const [
        DropdownMenuItem(value: 'Pending', child: Text('Pending', style: TextStyle(fontSize: 20))),
        DropdownMenuItem(value: 'Processing', child: Text('Processing',style: TextStyle(fontSize: 20))),
        DropdownMenuItem(value: 'Confirmed', child: Text('Confirmed', style: TextStyle(fontSize: 20))),
        DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled', style: TextStyle(fontSize: 20))),
      ],
//defining the function that will be called when the status is changed, the value parameter will be the new status selected from the dropdown menu
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
