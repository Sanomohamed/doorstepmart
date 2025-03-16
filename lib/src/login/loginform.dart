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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  
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
            'Sign In',
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 41, 39, 39),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              letterSpacing: 4.2, // Slightly improved spacing for elegance
            ),
          ),
          const SizedBox(height: 25),
          /// Email Input
          CustomTextField(hintText: 'Email', controller: emailController),
          const SizedBox(height: 35),

          /// Password Input
          CustomTextField(hintText: 'Password', obscureText: true, controller: passwordController),
          const SizedBox(height: 35),

          /// Login Button (Full Width for Better UX)
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
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(197, 0, 0, 0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 35),

          /// Google Sign-In Button (Full Width & Icon for Better Recognition)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              icon: FaIcon(FontAwesomeIcons.google, size: 25,color: const Color.fromARGB(255, 27, 34, 26)), // Use FontAwesomeIcons.google
              label: const Text(
                '  Sign In',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(197, 0, 0, 0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(76, 160, 235, 157), // Vibrant green
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(42),
                ),
                elevation: 9,
              ),
            ),
          ),
          const SizedBox(height: 20),
          /// Forgot Password (Centered & Styled)
           ForgotPassword(),
        ],
      ),
    ),
  );
}
}