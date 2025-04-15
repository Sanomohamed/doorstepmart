import 'package:doorstepmart/services/auth_service.dart';
import 'package:doorstepmart/src/custom_widgets.dart';          //importing the necessary packages and files
import 'package:doorstepmart/src/login/forgetpassword.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupFormState createState() => _SignupFormState();
}
class _SignupFormState extends State<SignupForm> {
  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  /// AuthService instance for authentication
  final AuthService _authService = AuthService();
  /// Method to handle registration
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
      nameController.text,
    );
    if (userCredential != null) {
      if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful.')),
        );
        Navigator.pushNamed(context, '/Landing');
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
      width: 400, 
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 145, 167, 145), 
        borderRadius: BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(19, 86, 90, 87),
            blurRadius: 40,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 41, 39, 39),
              fontWeight: FontWeight.bold,
              letterSpacing: 2.2, 
            ),
          ),
          const SizedBox(height: 10),
          CustomTextField(hintText: 'Name', controller: nameController),
          const SizedBox(height: 20),
          CustomTextField(hintText: 'Email', controller: emailController),
          const SizedBox(height: 20),
          CustomTextField(hintText: 'Password', obscureText: true, controller: passwordController),
          const SizedBox(height: 20),
          CustomTextField(hintText: 'Confirm Password', obscureText: true, controller: confirmPasswordController),
          const SizedBox(height: 25),
          /// This button triggers the registration process when pressed
            SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(76, 160, 235, 157),
                padding: const EdgeInsets.symmetric(vertical: 14), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(42),
                ),
                elevation: 9,
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(197, 0, 0, 0),
                ),
              ),
            ),
          ),
          ], 
          ),
      ),
    );
  }
}