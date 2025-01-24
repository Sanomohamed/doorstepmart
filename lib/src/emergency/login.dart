import 'package:doorstepmart/src/emergency/signup.dart';
import 'package:flutter/material.dart';
import '../custom_widgets.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD2DBD6),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2.0),
                  width: 500,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2DBD6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/image.png', // Replace with your image path
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 500,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF77AB8A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      CustomTextField(hintText: 'Email', controller: TextEditingController(),),
                      SizedBox(height: 10),
                      CustomTextField(hintText: 'Password', obscureText: true, controller: TextEditingController(),),
                      SizedBox(height: 20),
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
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18, // Text size
                            fontWeight: FontWeight.bold, // Bold text
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility),
                            color: Colors.white,
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                          ),
                          Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: (){
                              // Add your onPressed code here!
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));

                            },
                            child: Text("Don't have an account? Sign up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                     // SizedBox(height: 20),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                            icon: Icons.login,
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                          ),
                          SizedBox(width: 20),
                          CustomIconButton(
                            icon: Icons.apple,
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}