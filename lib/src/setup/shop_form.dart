import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/setup/widget/confirm_snackbar.dart';
import 'package:doorstepmart/src/setup/widget/location_dropdown.dart';
import 'package:doorstepmart/src/setup/widget/shop_image_picker.dart';     //importing the necessary packages and files
import 'package:doorstepmart/src/setup/widget/shop_name_field.dart';
import 'package:doorstepmart/src/setup/widget/submit_button.dart';
import 'package:doorstepmart/src/setup/widget/time_picker_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShopForm extends StatefulWidget {
  final Function(String, String, String, File?, List<String>, TimeOfDay?, TimeOfDay?) onSubmit;
  final bool isLoading;

  const ShopForm({super.key, required this.onSubmit, required this.isLoading});

  @override
  State<ShopForm> createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();

  String? _selectedState;
  String? _selectedCity;
  File? _pickedImage;
  List<String> selectedDays = [];
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  final List<String> states = [ 'Selangor', 'Kuala Lumpur'];
  final Map<String, List<String>> cities = {
    'Selangor': ['Kota Damansara', 'Petaling Jaya'],
    'Kuala Lumpur': ['Ampang', 'Cheras'],
  };



  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _pickTime(bool isOpening) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        isOpening ? openingTime = picked : closingTime = picked;
      });
    }
  }

 void _submitForm() {
  if (_formKey.currentState!.validate()) {
    _confirmBeforeCreate(context); 
  }
}

void _confirmBeforeCreate(BuildContext context) {
  showConfirmationSnackbar(
    context: context,
    message: "Are you sure you want to create this shop?",
    onConfirmed: () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final shopSnap = await FirebaseFirestore.instance
      //fetching the shop details from the firestore
          .collection('shops')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (shopSnap.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Only one shop per account")),
        );
        return;
      }
      widget.onSubmit(
        /// Call the onSubmit function passed from the parent widget
        _shopNameController.text.trim(),
        _selectedState ?? '',
        _selectedCity ?? '',
        _pickedImage,
        selectedDays,
        openingTime,
        closingTime,
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ShopImagePicker(image: _pickedImage, onPick: _pickImage),
              const SizedBox(height: 45),
              ShopNameField(controller: _shopNameController),
              const SizedBox(height: 30),
              LocationDropdowns(
                states: states,
                cities: cities,
                 selectedState: _selectedState,
                selectedCity: _selectedCity,
               onStateChanged: (value) {
               setState(() {
               _selectedState = value;
               _selectedCity = null;
            });
         },
         onCityChanged: (val) => setState(() => _selectedCity = val),
        ),
              const SizedBox(height: 30),
              TimePickerTile(
                label: "Opening Time",
                time: openingTime,
                onTap: () => _pickTime(true),
              ),
              const SizedBox(height: 30),
              TimePickerTile(
                label: "Closing Time",
                time: closingTime,
                onTap: () => _pickTime(false),
              ),
              const SizedBox(height: 45),
              SubmitButton(
                isLoading: widget.isLoading,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}