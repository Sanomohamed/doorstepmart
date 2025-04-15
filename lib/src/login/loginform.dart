import 'package:doorstepmart/src/custom_widgets.dart';
import 'package:doorstepmart/src/login/forgetpassword.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState(); 
}

class _LoginFormState extends State<LoginForm> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // AuthService instance for authentication
  final AuthService _authService = AuthService();

  // Method to handle login
void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

   // print('Email: $email'); // Debugging line
   // print('Password: $password'); // Debugging line

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
      if (mounted) {
        Navigator.pushNamed(context, '/Landing');
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }
// Method to handle Google Sign-In
  void _signInWithGoogle() async {
    final userCredential = await _authService.signInWithGoogle();

    if (userCredential != null) {
      if (mounted) {
        Navigator.pushNamed(context, '/Landing');
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed. Please try again.')),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  return Center(
    child: Container(
      width: 350, 
      padding: const EdgeInsets.all(15),
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
          /// Title
          const Text(
            'Sign In',
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 41, 39, 39),
              fontWeight: FontWeight.bold,
              letterSpacing: 2.2, 
            ),
          ),
          const SizedBox(height: 20),
          
          CustomTextField(hintText: 'Email', controller: emailController),
          const SizedBox(height: 25),
         
          CustomTextField(hintText: 'Password', obscureText: true, controller: passwordController),
          const SizedBox(height: 10),      
      
           ForgotPassword(),
           const SizedBox(height: 20),
         
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(76, 160, 235, 157), // Vibrant green
                padding: const EdgeInsets.symmetric(vertical: 14), // Improved padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(42), // More modern rounded corners
                ),
                elevation: 9,
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(197, 0, 0, 0),
                ),
              ),
            ),
          ),
           const SizedBox(height: 15),
  //Divider with Text
          Row(
            children: [
              const Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
    // Google Sign-In Button
Column(
  children: [
    // Text
    const Text(
      'Sign in with Google',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    ),
    const SizedBox(height: 10), // Space between text and button
    // Circular Icon Button
    Tooltip(
      message: 'Sign in with Google',
      child: SizedBox(
        width: 50, // Circular size
        height: 50, // Circular size
        child: ElevatedButton(
          onPressed: _signInWithGoogle,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(), // Circular shape
            padding: const EdgeInsets.all(0), // Remove padding
            backgroundColor: const Color.fromARGB(76, 160, 235, 157), // Background color
          ),
          child: const FaIcon(
            FontAwesomeIcons.google,
            size: 30,
            color: Color.fromARGB(255, 27, 34, 26),
          ),
        ),
      ),
    ),
  ],
),
       
          const SizedBox(height: 15),
        ],
      ),
    ),
  );
}
}