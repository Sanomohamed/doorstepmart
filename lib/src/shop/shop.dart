import 'package:doorstepmart/src/setup/shop_productgrid.dart';
import 'package:doorstepmart/src/shop/header/header_section.dart';
import 'package:flutter/material.dart';
//importing the necessary packages and files for the MiniMartPage widget
//The widget for the shop user interface of the app

class MiniMartPage extends StatefulWidget {
  const MiniMartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MiniMartPageState createState() => _MiniMartPageState();
}

/// The state class for MiniMartPage
/// This class manages the state of the MiniMartPage widget
class _MiniMartPageState extends State<MiniMartPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; ///Keeps state

  //manually refresh ShopProductGrid if needed
  final GlobalKey<ShopProductGridState> _gridKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to ensure the state is kept alive
    // This method is called when the widget is built.
    return Scaffold(
      // Scaffold provides a basic structure for the app's UI.
      backgroundColor: const Color.fromARGB(244, 228, 243, 230),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _gridKey.currentState?.refresh(); 
              },
              child: ShopProductGrid(key: _gridKey), 
            ),
          ),
        ],
      ),
    );
  }
}
