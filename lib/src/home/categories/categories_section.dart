import 'package:doorstepmart/src/home/categories/category_header.dart';
import 'package:doorstepmart/src/home/categories/category_icons_scroller.dart';
import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        CategoryHeader(),
        CategoryIconScroller(),
      ],
    );
  }
}
