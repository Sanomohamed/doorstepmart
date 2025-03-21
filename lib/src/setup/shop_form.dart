import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ShopForm extends StatefulWidget {
  final Function(String, String, String, File?, List<String>, TimeOfDay?, TimeOfDay?) onSubmit;
  final bool isLoading;

  const ShopForm({super.key, required this.onSubmit, required this.isLoading});

  @override
  _ShopFormState createState() => _ShopFormState();
}

class _ShopFormState extends State<ShopForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _contactController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _postCodeController = TextEditingController();

  String? _selectedState;
  String? _selectedCity;
  File? _pickedImage;

  final List<String> states = ['California', 'Texas', 'New York', 'Florida'];
  final Map<String, List<String>> cities = {
    'California': ['Los Angeles', 'San Francisco', 'San Diego'],
    'Texas': ['Houston', 'Austin', 'Dallas'],
    'New York': ['New York City', 'Buffalo', 'Albany'],
    'Florida': ['Miami', 'Orlando', 'Tampa'],
  };

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _shopNameController.text.trim(),
        _selectedState ?? '',
        _selectedCity ?? '',
        _pickedImage,
        selectedDays,
        openingTime,
        closingTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage!)
                  : const AssetImage('assets/profile.png') as ImageProvider,
              child: _pickedImage == null ? const Icon(Icons.camera_alt, size: 40, color: Colors.white) : null,
            ),
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _shopNameController,
            decoration: InputDecoration(
              labelText: 'Shop Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) => value!.isEmpty ? "Enter shop name" : null,
          ),
          const SizedBox(height: 20),

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
                    .toList()
                : <DropdownMenuItem<String>>[],
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
            onPressed: widget.isLoading ? null : _submitForm,
            child: widget.isLoading ? const CircularProgressIndicator() : const Text('Create Shop'),
          ),
        ],
      ),
    );
  }
}
