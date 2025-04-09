import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  final bool isDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCard({
    super.key,
    required this.data,
    required this.docId,
    required this.isDefault,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onSetDefault,
        child: ListTile(
          title: Text(data['fullName'] ?? 'No Name'),
          subtitle: Text("${data['street']}, ${data['city']}, ${data['state']}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
            ],
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isDefault ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isDefault ? Colors.green : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                isDefault ? "Default" : "Tap to Set",
                style: TextStyle(
                  fontSize: 12,
                  color: isDefault ? Colors.green : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
