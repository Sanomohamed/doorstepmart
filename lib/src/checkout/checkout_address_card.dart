import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/address/manage_addresses_page.dart';

class CheckoutAddressCard extends StatelessWidget {
  final Function(Map<String, dynamic>) onAddressSelected;

  const CheckoutAddressCard({super.key, required this.onAddressSelected});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Text("You must be logged in.");

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .orderBy('isDefault', descending: true)
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        if (snapshot.data!.docs.isEmpty) {
          return ElevatedButton.icon(
            icon: const Icon(Icons.add_location_alt),
            label: const Text("Add Delivery Address"),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageAddressesPage()),
              );
              onAddressSelected({}); // return empty to force reload
            },
          );
        }

        final doc = snapshot.data!.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(data['fullName']),
            subtitle: Text("${data['street']}, ${data['city']}, ${data['state']} - ${data['postalCode']}\n📞 ${data['phone']}"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageAddressesPage()),
              );
              onAddressSelected(data); // update on return
            },
          ),
        );
      },
    );
  }
}
