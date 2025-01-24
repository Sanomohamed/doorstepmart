import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class NotificationPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'image': 'assets/image.png', // Replace with your image path
      'title': 'New Offer!',
      'description': 'Get 20% off on your next purchase.',
      'date': '2023-10-01',
      'time': '10:00 AM'
    },
    {
      'image': 'assets/image.png', // Replace with your image path
      'title': 'Order Shipped',
      'description': 'Your order #12345 has been shipped.',
      'date': '2023-10-02',
      'time': '2:00 PM'
    },
    // Add more notifications here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                notification['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(notification['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification['description']),
                  SizedBox(height: 5),
                  Text(
                    '${notification['date']} at ${notification['time']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}