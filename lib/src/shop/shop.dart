import 'package:doorstepmart/src/setup/shop_productgrid.dart';
import 'package:doorstepmart/src/shop/headeersection.dart'; // ✅ Import your ShopProductGrid
import 'package:flutter/material.dart';

class MiniMartPage extends StatefulWidget {
  const MiniMartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MiniMartPageState createState() => _MiniMartPageState();
}

class _MiniMartPageState extends State<MiniMartPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // ✅ Keeps state

  // Optional: manually refresh ShopProductGrid if needed
  final GlobalKey<ShopProductGridState> _gridKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _gridKey.currentState?.refresh(); // ✅ call manual refresh method if needed
              },
              child: ShopProductGrid(key: _gridKey), // ✅ ShopProductGrid replaces ProductGrid
            ),
          ),
        ],
      ),
    );
  }
}
