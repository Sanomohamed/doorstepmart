import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class CreateShopPage extends StatefulWidget {
  const CreateShopPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateShopPageState createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();

  String? _selectedState;
  String? _selectedCity;
  File? _pickedImage;
  bool _isLoading = false;

  final List<String> states = ['California', 'Texas', 'New York', 'Florida'];
  final Map<String, List<String>> cities = {
    'California': ['Los Angeles', 'San Francisco', 'San Diego'],
    'Texas': ['Houston', 'Austin', 'Dallas'],
    'New York': ['New York City', 'Buffalo', 'Albany'],
    'Florida': ['Miami', 'Orlando', 'Tampa'],
  };

  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  List<String> selectedDays = [];
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickTime({required bool isOpening}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isOpening) {
          openingTime = pickedTime;
        } else {
          closingTime = pickedTime;
        }
      });
    }
  }

Future<void> _createShop() async {
  if (!_formKey.currentState!.validate()) return;
  if (_pickedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please pick a shop profile image')),
    );
    return;
  }
  if (openingTime == null || closingTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select operating hours')),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    // ✅ CHECK IF USER ALREADY HAS A SHOP
    QuerySnapshot shopSnapshot = await FirebaseFirestore.instance
        .collection("shops")
        .where("userId", isEqualTo: user.uid)
        .get();

    if (shopSnapshot.docs.isNotEmpty) {
      // User already has a shop, show error message
      setState(() => _isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already have a shop.')),
      );
      return;
    }

    // ✅ IF NO SHOP EXISTS, CREATE A NEW ONE
    String shopId = const Uuid().v4();
    String imageUrl = await _uploadImage(shopId);

    Map<String, dynamic> shopData = {
      "shopId": shopId,
      "userId": user.uid,
      "shopName": _shopNameController.text.trim(),
      "location": {
        "state": _selectedState,
        "city": _selectedCity,
        "postCode": _postCodeController.text.trim(),
      },
      "contact": _contactController.text.trim(),
      "operatingDays": selectedDays,
      "operatingHours": {
        // ignore: use_build_context_synchronously
        "opening": openingTime!.format(context),
        // ignore: use_build_context_synchronously
        "closing": closingTime!.format(context),
      },
      "shopImageUrl": imageUrl,
      "createdAt": Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection("shops").doc(shopId).set(shopData);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shop created successfully')),
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error creating shop: $e')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<String> _uploadImage(String shopId) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('shops/$shopId/profile.jpg')
        .putFile(_pickedImage!);

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Widget _buildTimePicker(String label, TimeOfDay? time, bool isOpening) {
    return ListTile(
      title: Text(time == null ? "$label: Not selected" : "$label: ${time.format(context)}"),
      trailing: const Icon(Icons.access_time),
      onTap: () => _pickTime(isOpening: isOpening),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Shop')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Shop Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : const AssetImage('assets/default_shop.png') as ImageProvider,
                  child: _pickedImage == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Shop Name
              TextFormField(
                controller: _shopNameController,
                decoration: InputDecoration(
                  labelText: 'Shop Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? "Enter shop name" : null,
              ),
              const SizedBox(height: 20),

              // State Selection
              DropdownButtonFormField<String>(
                value: _selectedState,
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: states.map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedState = value;
                    _selectedCity = null;
                  });
                },
              ),
              const SizedBox(height: 20),

              // City Selection
            DropdownButtonFormField<String>(
  value: _selectedCity,
  decoration: InputDecoration(
    labelText: 'City',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  ),
  items: (_selectedState != null && cities.containsKey(_selectedState!))
      ? cities[_selectedState!]!
          .map<DropdownMenuItem<String>>((String city) => DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              ))
          .toList() // Ensure it is a List<DropdownMenuItem<String>>
      : <DropdownMenuItem<String>>[], // Return an empty list if no state is selected
  onChanged: (String? value) {
    setState(() {
      _selectedCity = value;
    });
  },
),
              const SizedBox(height: 20),

              _buildTimePicker("Opening Time", openingTime, true),
              const SizedBox(height: 20),
              _buildTimePicker("Closing Time", closingTime, false),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _createShop,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Create Shop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
