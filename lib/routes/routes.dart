import 'package:get/get.dart';
import 'package:women_safety_app/navbar/navbar.dart';
import 'package:women_safety_app/pages/contact.dart';
import 'package:women_safety_app/pages/home.dart';
import 'package:women_safety_app/pages/location.dart';
import 'package:women_safety_app/pages/setting.dart';
import 'package:women_safety_app/login_page.dart';
import 'package:women_safety_app/signup_page.dart';

class Apppage{
  static List<GetPage> routes = [
    GetPage(name: navbar, page: ()=> Navbar()),
    GetPage(name: home, page: () => Home()),
    GetPage(name: contact, page: () => Note()),
    GetPage(name: location, page: () => Chart()),
    GetPage(name: setting, page: () => Setting()),
    GetPage(name: login, page: () =>LoginScreen()),
    GetPage(name: signup, page: () => SignupPage()),




  ];
  static getnavbar() => navbar;
  static gethome() => home;
  static getcontact() => contact;
  static getlocation() => location;
  static getsetting() => setting;
  static getlogin() => login;
  static getsignup() => signup;
  //

  static String navbar = '/navbar';
  static String home = '/home';
  static String contact = '/contact';
  static String location = '/location';
  static String setting = '/setting';
  static String login= '/login';
  static String signup = '/signup';
}