import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../utils/app_constant.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstant.appMainColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: GNav(
          gap: 8,
          backgroundColor: AppConstant.appMainColor,
          activeColor: Colors.white,
          color: Colors.white,
          tabBackgroundColor: AppConstant.appSecondaryColor,
          selectedIndex: 0,
          onTabChange: (index) {
            // print('Tapped index: $index');
          },
          iconSize: 24,
          padding: const EdgeInsets.all(10),
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.shopping_bag, text: 'Products'),
            GButton(icon: Icons.hourglass_empty_rounded, text: 'Pending'),
            GButton(icon: Icons.receipt, text: 'Reports'),
          ],
        ),
      ),
    );
  }
}
