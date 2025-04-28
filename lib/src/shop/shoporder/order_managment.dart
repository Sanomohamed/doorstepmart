// lib/src/shop/shoporder/shop_order_management_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/order/widget/order_status_toggle.dart';
import 'package:doorstepmart/src/shop/shoporder/orderlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopOrderManagementPage extends StatefulWidget {
  const ShopOrderManagementPage({super.key});

  @override
  State<ShopOrderManagementPage> createState() =>
      _ShopOrderManagementPageState();
}

class _ShopOrderManagementPageState extends State<ShopOrderManagementPage> {
  String? _shopId;
  bool _loading = true;
  String _selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    _fetchShopId();
  }

  Future<void> _fetchShopId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }
    final snapshot = await FirebaseFirestore.instance
        .collection('shops')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();
    setState(() {
      _shopId =
          snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_shopId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Shop Order Management'),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Text('No shop found for this user.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Order Management'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // 📊 Status Toggle
              OrderStatusToggle(
                selectedStatus: _selectedStatus,
                onStatusChanged: (status) {
                  setState(() => _selectedStatus = status);
                },
              ),

              const SizedBox(height: 12),

              // 📋 Filtered Order List
              Expanded(
                child: OrderList(
                  shopId: _shopId!,
                  status: _selectedStatus,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
