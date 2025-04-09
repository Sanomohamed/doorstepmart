import 'package:flutter/material.dart';
//importing the necessary packages for the dropdown menu

class OrderStatusDropdown extends StatelessWidget {
  //creating a stateless widget for the order status dropdown menu
  final String currentStatus;
  //defining the current status of the order
  final Function(String) onChanged;
  //defining a function that will be called when the status is changed

  const OrderStatusDropdown({
    //constructor for the OrderStatusDropdown widget
    super.key,
    required this.currentStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    //building the widget
    return DropdownButton<String>(
      //creating a dropdown button with a string value
      value: currentStatus,
      isExpanded: true,
      items: const [
        //defining the items in the dropdown menu
        DropdownMenuItem(value: 'Pending', child: Text('Pending', style: TextStyle(fontSize: 20))),
        DropdownMenuItem(value: 'Processing', child: Text('Processing',style: TextStyle(fontSize: 20))),
        DropdownMenuItem(value: 'Confirmed', child: Text('Confirmed', style: TextStyle(fontSize: 20))),
        DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled', style: TextStyle(fontSize: 20))),
      ],
      onChanged: (value) {
        //defining the function that will be called when the status is changed
        //the value parameter will be the new status selected from the dropdown menu
        if (value != null) onChanged(value);
      },
    );
  }
}
