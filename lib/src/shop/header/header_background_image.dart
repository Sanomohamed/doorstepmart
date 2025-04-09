import 'package:flutter/material.dart';
//importing the necessary packages for the header background image

class HeaderBackgroundImage extends StatelessWidget {
  // This widget is used to create a header background image with a gradient overlay.
  // It is a stateless widget that takes no parameters and builds a container
  const HeaderBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    // The build method returns a container with a background image and a gradient overlay.
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        // This container is used to create a gradient overlay on top of the background image.
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              // ignore: deprecated_member_use
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
