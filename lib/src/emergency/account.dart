import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 137, 185, 138),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: const Icon(Icons.person, size: 40), // Icon used instead of image
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 15),
                            onPressed: () {
                              // Handle edit profile action
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Username', // Replace with actual username
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Handle settings action
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // My Purchase Section
          const Text(
            'My Purchase',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('View Purchase History'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle view purchase history action
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Handle orders action
                },
              ),
              IconButton(
                icon: const Icon(Icons.local_shipping),
                onPressed: () {
                  // Handle received action
                },
              ),
              IconButton(
                icon: const Icon(Icons.check_circle),
                onPressed: () {
                  // Handle completed action
                },
              ),
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  // Handle canceled action
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // More Activity Section
          const Text(
            'More Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('My Favorite'),
            onTap: () {
              // Handle my favorite action
            },
          ),
          ListTile(
            leading: const Icon(Icons.remove_red_eye),
            title: const Text('Recently Viewed'),
            onTap: () {
              // Handle recently viewed action
            },
          ),
          const SizedBox(height: 16.0),
          // Support Section
          const Text(
            'Support',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: const Icon(Icons.help_center),
            title: const Text('Help Center'),
            onTap: () {
              // Handle help center action
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat with AI'),
            onTap: () {
              // Handle chat with AI action
            },
          ),
          const Divider(),
          // More Products Section
          const Text(
            'More Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: 10, // Replace with actual product count
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag, // Icon used instead of image
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Product Name',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            '\$Price',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16.0),
          // Logout Button
          ElevatedButton(
            onPressed: () {
              // Handle logout action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
