import 'package:flutter/material.dart';
import 'package:doorstepmart/src/profile/profile_form.dart';
import 'package:doorstepmart/src/account/account_page_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _controller = AccountPageController(context); 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 3, 
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color(0xFFF8F8F8), 
        child: Column(
          children: [
            const Expanded(
              child: ProfileForm(), 
            ),
            const SizedBox(height: 20),

            // Logout Button
            Align(
              alignment: Alignment.center, 
              child: SizedBox(
                width: 200, 
                child: ElevatedButton.icon(
                  onPressed: _controller.logout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  icon: _controller.isLoggingOut
                      ? const SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    _controller.isLoggingOut ? 'Logging out...' : 'Logout',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}