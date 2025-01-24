import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    super.key,
   required this.hintText,
    this.obscureText = false, required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          // ignore: deprecated_member_use
          fillColor: Colors.white.withOpacity(0.3),
        ),
        style: TextStyle(color: Colors.white),
        obscureText: obscureText,
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget{
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context){
    return IconButton(
      icon: Icon(icon),
      color: Colors.white,
      iconSize: 40,
      onPressed: onPressed,
    );
  }
}