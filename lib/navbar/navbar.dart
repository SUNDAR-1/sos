import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:women_safety_app/controller/controller.dart';
import 'package:women_safety_app/pages/contact.dart';
import 'package:women_safety_app/pages/home.dart';
import 'package:women_safety_app/pages/location.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});
  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final controller = Get.put(NavBarController());
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<NavBarController>(builder: (context) {
      return Scaffold(
        body: IndexedStack(
          index: controller.tabIndex,
          children: const [Home(), Note(), Chart()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 100.0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.grey,
          currentIndex: controller.tabIndex,
          onTap: controller.changeTabIndex,
          items: [
            _bottombarItem(IconlyBold.home, "Home"),
            _bottombarItem(IconlyBold.user_3, "Contact"),
            _bottombarItem(IconlyBold.location, "Location"),
 
        ],

        ),
        );
    });
    }
  }

  _bottombarItem(IconData icon, String label ) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  } 