import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/services/auth_service.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';

class AccountPageController {
  final BuildContext context;
  final AuthService authService = AuthService();
  bool _isLoggingOut = false;

  AccountPageController(this.context);

  bool get isLoggingOut => _isLoggingOut;

  void logout() async {
    if (_isLoggingOut) return;

    _setLoggingOut(true);

    try {
      Provider.of<CartModel>(context, listen: false).clearCart();
      await authService.signOut();

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logout failed: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (context.mounted) {
        _setLoggingOut(false);
      }
    }
  }

  void _setLoggingOut(bool value) {
    _isLoggingOut = value;
    if (context.mounted) {
      (context as Element).markNeedsBuild();
    }
  }
}
