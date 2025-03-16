import 'package:doorstepmart/services/auth_service.dart';
import 'package:doorstepmart/src/custom_widgets.dart';
import 'package:doorstepmart/src/login/forgetpassword.dart';
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
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful.')),
        );
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
    return Center(
       child: Container(
      width: 400, // Adjusted width for better responsiveness
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 145, 167, 145), // Soothing modern green
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
        crossAxisAlignment: CrossAxisAlignment.center, // Center alignment for better balance
        children: [
          /// Title
          const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 35,
              color: Color.fromARGB(255, 41, 39, 39),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              letterSpacing: 4.2, // Slightly improved spacing for elegance
            ),
          ),
          const SizedBox(height: 15),
          CustomTextField(hintText: 'Name', controller: nameController),
          const SizedBox(height: 29),
          CustomTextField(hintText: 'Email', controller: emailController),
          const SizedBox(height: 28),
          CustomTextField(hintText: 'Password', obscureText: true, controller: passwordController),
          const SizedBox(height: 29),
          CustomTextField(hintText: 'Confirm Password', obscureText: true, controller: confirmPasswordController),
          const SizedBox(height: 30),
               SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(76, 160, 235, 157), // Vibrant green
                padding: const EdgeInsets.symmetric(vertical: 14), // Improved padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(42), // More modern rounded corners
                ),
                elevation: 9,
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(197, 0, 0, 0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          ], 
          ),
      ),
    );
  }
}