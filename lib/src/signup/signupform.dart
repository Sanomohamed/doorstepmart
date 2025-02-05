import 'package:doorstepmart/services/auth_service.dart';
import 'package:doorstepmart/src/custom_widgets.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupFormState createState() => _SignupFormState();
}
class _SignupFormState extends State<SignupForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    final userCredential = await _authService.registerWithEmailPassword(
      emailController.text,
      passwordController.text,
    );

    if (userCredential != null) {
      if (mounted) {
        Navigator.pushNamed(context, '/Landing');
      }
    } else {
      // Show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF77AB8A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Signup',
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          CustomTextField(hintText: 'Name', controller: nameController),
          CustomTextField(hintText: 'Email', controller: emailController),
          CustomTextField(hintText: 'Password', obscureText: true, controller: passwordController),
          CustomTextField(hintText: 'Confirm Password', obscureText: true, controller: confirmPasswordController),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 88, 187, 126),
              elevation: 5, // Elevation
              shadowColor: Colors.black, // Shadow color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Border radius
              ),
            ),
            child: const Text(
              'Signup',
              style: TextStyle(
                fontSize: 18, // Text size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.white, // Text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}