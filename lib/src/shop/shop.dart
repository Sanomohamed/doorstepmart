// lib/src/setup/mini_mart_page.dart
import 'package:doorstepmart/src/shop/header/header_section.dart';
import 'package:doorstepmart/src/setup/shop_productgrid.dart';
import 'package:flutter/material.dart';

class MiniMartPage extends StatefulWidget {
  const MiniMartPage({Key? key}) : super(key: key);

  @override
  _MiniMartPageState createState() => _MiniMartPageState();
}

class _MiniMartPageState extends State<MiniMartPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<ShopProductGridState> _gridKey = GlobalKey();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderSection(
            onSearchChanged: (val) {
              setState(() => _searchQuery = val);
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await _gridKey.currentState?.refresh(),
              child: ShopProductGrid(
                key: _gridKey,
                searchQuery: _searchQuery,
              ),
            ),
          ),
        ],
      ),
    );
  }
}