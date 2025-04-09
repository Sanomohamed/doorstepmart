import 'package:flutter/material.dart';
//importing the necessary packages for the CircleIconButton widget

class CircleIconButton extends StatelessWidget {
  // This widget is used to create a circular icon button with a shadow effect.
  // It is a stateless widget that takes an icon, a callback function, and optional colors for the icon and background.
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color backgroundColor;

  const CircleIconButton({
    //constructor for the CircleIconButton widget
    // It takes the following parameters:
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    // The build method returns an InkWell widget that wraps a Container widget.
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 26, color: iconColor),
        ),
      ),
    );
  }
}
