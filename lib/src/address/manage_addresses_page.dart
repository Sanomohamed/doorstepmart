import 'package:doorstepmart/services/address_services.dart';
import 'package:doorstepmart/src/address/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/address/edit_add_address.dart';

class ManageAddressesPage extends StatefulWidget {
  const ManageAddressesPage({super.key});

  @override
  State<ManageAddressesPage> createState() => _ManageAddressesPageState();
}

class _ManageAddressesPageState extends State<ManageAddressesPage> {
  final AddressService _addressService = AddressService();

  void _confirmDelete(String docId) async {
    final confirmed = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      await _addressService.deleteAddress(docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Delivery Addresses"), backgroundColor: Colors.green),
      body: StreamBuilder(
        stream: _addressService.addressStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final addresses = snapshot.data!.docs;

          if (addresses.isEmpty) return const Center(child: Text("No addresses found. Add one!"));

          return ListView.builder(
            itemCount: addresses.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final doc = addresses[index];
              final data = doc.data() as Map<String, dynamic>;
              final docId = doc.id;
              final isDefault = data['isDefault'] == true;

              return AddressCard(
                data: data,
                docId: docId,
                isDefault: isDefault,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditAddressPage(addressId: docId, existingData: data),
                    ),
                  );
                },
                onDelete: () => _confirmDelete(docId),
                onSetDefault: () async {
                  await _addressService.setAsDefault(docId);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Default address updated")),
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditAddressPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
