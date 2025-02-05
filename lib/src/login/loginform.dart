import 'package:doorstepmart/src/custom_widgets.dart';
import 'package:doorstepmart/src/login/forgetpassword.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/services/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
  
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  
void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print('Email: $email'); // Debugging line
    print('Password: $password'); // Debugging line


    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    final userCredential = await _authService.signInWithEmailPassword(
      email,
      password,
    );

    if (userCredential != null) {
      // Navigate to the landing page or show a success message
      if (mounted) {
        Navigator.pushNamed(context, '/Landing');
      }
    } else {
      // Show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  void _signInWithGoogle() async {
    final userCredential = await _authService.signInWithGoogle();

    if (userCredential != null) {
      // Navigate to the landing page or show a success message
      if (mounted) {
        Navigator.pushNamed(context, '/Landing');
      }
    } else {
      // Show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed. Please try again.')),
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
            'Login',
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          CustomTextField(hintText: 'Email', controller: emailController),
          const SizedBox(height: 10),
          CustomTextField(hintText: 'Password', obscureText: true, controller: passwordController),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:_login,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 88, 187, 126),
              elevation: 5, // Elevation
              shadowColor: Colors.black, // Shadow color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Border radius
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 18, // Text size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.white, // Text color
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:_signInWithGoogle,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 88, 187, 126),
              elevation: 5, // Elevation
              shadowColor: Colors.black, // Shadow color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Border radius
              ),
            ),
            child: const Text(
              'Google Sign-In',
              style: TextStyle(
                fontSize: 18, // Text size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.white, // Text color
              ),
            ),
          ),
          ForgotPassword(),
        ],
      ),
    );
  }
}