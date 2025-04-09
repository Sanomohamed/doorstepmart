import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/setup/widget/confirm_snackbar.dart';
import 'package:doorstepmart/src/setup/widget/location_dropdown.dart';
import 'package:doorstepmart/src/setup/widget/shop_image_picker.dart';
import 'package:doorstepmart/src/setup/widget/shop_name_field.dart';
import 'package:doorstepmart/src/setup/widget/submit_button.dart';
import 'package:doorstepmart/src/setup/widget/time_picker_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//importing the necessary packages and files

class ShopForm extends StatefulWidget {
  /// Callback function to handle form submission
  /// This function will be called when the form is submitted.
  final Function(String, String, String, File?, List<String>, TimeOfDay?, TimeOfDay?) onSubmit;
  final bool isLoading;

  const ShopForm({super.key, required this.onSubmit, required this.isLoading});

  @override
  State<ShopForm> createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  /// Form key to validate the form fields
  /// This key is used to identify the form and validate its fields.
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();

  String? _selectedState;
  String? _selectedCity;
  File? _pickedImage;

  final List<String> states = ['California', 'Texas', 'New York', 'Florida'];
  /// A map of states and their corresponding cities
  /// This map is used to populate the city dropdown based on the selected state.
  final Map<String, List<String>> cities = {
    'California': ['Los Angeles', 'San Francisco', 'San Diego'],
    'Texas': ['Houston', 'Austin', 'Dallas'],
    'New York': ['New York City', 'Buffalo', 'Albany'],
    'Florida': ['Miami', 'Orlando', 'Tampa'],
  };
  /// A list of selected days for the shop's operation
  /// This list is used to store the days of the week when the shop is open.
  List<String> selectedDays = [];
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  Future<void> _pickImage() async {
    /// Show image picker dialog to select an image from the gallery
    /// This function uses the ImagePicker package to allow the user to select an image.
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    /// Check if the user picked an image
    /// If an image is picked, update the state with the selected image
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _pickTime(bool isOpening) async {
    /// Show time picker dialog to select opening or closing time
    /// This function uses the showTimePicker method to allow the user to select a time.
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    /// Check if the user picked a time
    /// If a time is picked, update the state with the selected time
    if (picked != null) {
      setState(() {
        isOpening ? openingTime = picked : closingTime = picked;
      });
    }
  }

 void _submitForm() {
  /// Validate the form fields and show a confirmation dialog before submission
  /// This function checks if the form is valid and then calls the _confirmBeforeCreate method.
  if (_formKey.currentState!.validate()) {
    _confirmBeforeCreate(context); 
  }
}

void _confirmBeforeCreate(BuildContext context) {
  /// Show a confirmation dialog before creating the shop
  /// This function uses the showConfirmationSnackbar method to display a confirmation message.
  showConfirmationSnackbar(
    context: context,
    message: "Are you sure you want to create this shop?",
    onConfirmed: () async {
      /// Check if the user is logged in and if they already have a shop
      /// This function uses the FirebaseAuth and FirebaseFirestore packages to check the user's status.
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final shopSnap = await FirebaseFirestore.instance
      //fetching the shop details from the firestore
          .collection('shops')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (shopSnap.docs.isNotEmpty) {
        /// If the user already has a shop, show an error message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Only one shop per account")),
        );
        return;
      }
      widget.onSubmit(
        /// Call the onSubmit function passed from the parent widget
        /// and pass the form data to it
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
