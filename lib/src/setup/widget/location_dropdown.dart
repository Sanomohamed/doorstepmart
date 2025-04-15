import 'package:flutter/material.dart';

class LocationDropdowns extends StatelessWidget {
  final List<String> states;
  final Map<String, List<String>> cities;
  final String? selectedState;
  final String? selectedCity;
  final Function(String?) onStateChanged;
  final Function(String?) onCityChanged;

  const LocationDropdowns({
    super.key,
    required this.states,
    required this.cities,
    required this.selectedState,
    required this.selectedCity,
    required this.onStateChanged,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    // The [build] method returns a [Column] widget that contains two dropdown menus.
    final cityOptions = cities[selectedState] ?? [];

    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedState,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'State',
            labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: states
              .map((state) => DropdownMenuItem(value: state, child: Text(state)))
              .toList(),
          onChanged: onStateChanged,
        ),

        const SizedBox(height: 20),
        
        DropdownButtonFormField<String>(
          value: selectedCity,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'City',
            labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: cityOptions
              .map((city) => DropdownMenuItem(value: city, child: Text(city)))
              .toList(),
          onChanged: onCityChanged,
        ),
      ],
    );
  }
}
