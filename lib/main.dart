import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_safety_app/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();

  // Check if the user is already logged in
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}
class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
           debugShowCheckedModeBanner: false,
           initialRoute: isLoggedIn ? Apppage.getnavbar() : Apppage.getlogin(),
           getPages: Apppage.routes,

      
    );
  }
}






 