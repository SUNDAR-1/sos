import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:get/get.dart';
import 'package:women_safety_app/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => AppBar().preferredSize;
    
    Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);

      Get.offNamed(Apppage.login);
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.lightBlue,
      automaticallyImplyLeading: false,
      title: Text("PAAVAI"),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (String choice) {
           
            if (choice == 'Profile') {
              
            } 
            else if (choice == 'Settings') {
              Get.toNamed(Apppage.setting);
            }
            else if (choice == 'About') {
            }
            else if (choice=='Logout') {
              _handleLogout(context);

            }
          },
          itemBuilder: (BuildContext context) {
            return [
               PopupMenuItem<String>(
                value: 'Profile',
                child: Row(
                  children: [
                    Icon(
                      IconlyBold.profile,
                      size: 24, // Adjust the size as needed.
                      color: Colors.lightBlue, // Adjust the color as needed.
                    ),
                    SizedBox(width: 16), // Add spacing between icon and text
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Row(
                  children: [
                    Icon(
                      IconlyBold.setting,
                      size: 24, 
                      color: Colors.lightBlue, 
                    ),
                    SizedBox(width: 16), 
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'About',
                child: Row(
                  children: [
                    Icon(
                      IconlyBold.info_square,
                      size: 24, 
                      color: Colors.lightBlue, 
                    ),
                    SizedBox(width: 16), 
                    Text('About'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Row(
                  children: [
                    Icon(
                      IconlyBold.logout,
                      size: 24, 
                      color: Colors.lightBlue, 
                    ),
                    SizedBox(width: 16), 
                    Text('Logout'),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}
