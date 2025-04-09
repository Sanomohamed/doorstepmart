import 'package:flutter/material.dart';
/// This widget is used to create a pair of dropdowns for selecting a state and a city.
/// The first dropdown allows the user to select a state, and the second dropdown allows the user to select a city based on the selected state.

class LocationDropdowns extends StatelessWidget {
  /// The [LocationDropdowns] widget is a stateless widget that creates two dropdown menus:
  final List<String> states;
  //final list of states to be displayed in the first dropdown
  /// - The first dropdown allows the user to select a state.
  final Map<String, List<String>> cities;
  //final map of cities where the key is the state and the value is a list of cities in that state
  /// - The second dropdown allows the user to select a city based on the selected state.
  final String? selectedState;
  //the currently selected state in the first dropdown
  /// - The selected state is passed as a parameter to the widget.
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
        //  State Dropdown
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
              //convert the list of states to a list of DropdownMenuItem widgets
              //each DropdownMenuItem widget has a value and a child widget (Text widget displaying the state name)
              .toList(),
          onChanged: onStateChanged,
          //when the user selects a state, the onStateChanged function is called with the selected state as an argument
          //this function is passed as a parameter to the widget
        ),

        const SizedBox(height: 20),

        // ✅ City Dropdown (dependent)
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
