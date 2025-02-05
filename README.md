# doorstepmart

A new Flutter project.



class LoginForm extends StatelessWidget {

  const LoginForm({super.key});



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

          CustomTextField(hintText: 'Email', controller: TextEditingController(),),

          const SizedBox(height: 10),

          CustomTextField(hintText: 'Password', obscureText: true, controller: TextEditingController(),),

          const SizedBox(height: 20),

          ElevatedButton(

            onPressed: () {

              // Add your onPressed code here!

            },

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

          ForgotPassword(),

        ],

      ),

    );

  }

}






import 'package:doorstepmart/src/custom_widgets.dart';
import 'package:flutter/material.dart';


class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

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
          CustomTextField(hintText: 'Name', controller: TextEditingController(),),
          CustomTextField(hintText: 'Email', controller: TextEditingController(),),
          CustomTextField(hintText: 'Password', obscureText: true, controller: TextEditingController(),),
          CustomTextField(hintText: 'Confirm Password', obscureText: true, controller: TextEditingController(),),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add your onPressed code here!
            },
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