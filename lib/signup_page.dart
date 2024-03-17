import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:women_safety_app/routes/routes.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _registerUser() async {
  
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      final String confirmPassword = confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        // Passwords do not match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
          ),
        );
        return;
      }

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
       Get.offNamed(Apppage.location);
      }
    } 
    catch (e) {
      // Handle registration errors
      print('Error during registration: $e');
      String errorMessage =
          "Registration failed. Please try again."; // Default error message

      if (e is FirebaseAuthException) {
        // Handle Firebase authentication errors
        errorMessage = e.message ?? "An unknown error occurred.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xfff48fb1),
                    Color(0xFFF06292),
                    Color(0xFFEC407A),
                    Color(0XFFE91E63),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 120,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                    buildEmail(),
                    SizedBox(height: 20),
                    buildPassword(),
                    SizedBox(height: 20),
                    buildConfirmPassword(),
                    SizedBox(height: 20),
                    buildSignupBtn(),
                    buildLoginLink(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Define your input fields, buttons, and links here...

  // Example functions for input fields and buttons:
  Widget buildEmail() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget> [
      Text(
        'Email',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2)
            )
          ]
        ),
       height: 60,
       child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        style: TextStyle(
          color: Colors.black87
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(
            Icons.email,
            color: Color(0xff5ac18e),
          ),
          hintText: 'Email',
          hintStyle: TextStyle(
            color: Colors.black38
          )
        ),
        )
      )
    ]
  );
}

Widget buildPassword() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget> [
      Text(
        'Password',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2)
            )
          ]
        ),
       height: 60,
       child: TextField(
        obscureText: true,
        controller: passwordController,
        style: TextStyle(
          color: Colors.black87
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(
            Icons.lock,
            color: Color(0xff5ac18e),
          ),
          hintText: 'Password',
          hintStyle: TextStyle(
            color: Colors.black38
          )
        ),
        )
      )
    ]
  );
}


 Widget buildConfirmPassword() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget> [
      Text(
        'Confirm Password',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2)
            )
          ]
        ),
       height: 60,
       child: TextField(
        obscureText: true,
        controller: confirmPasswordController,
        style: TextStyle(
          color: Colors.black87
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(
            Icons.lock,
            color: Color(0xff5ac18e),
          ),
          hintText: 'Confirm Password',
          hintStyle: TextStyle(
            color: Colors.black38
          )
        ),
        )
      )
    ]
  );
}


  Widget buildSignupBtn(){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 25),
    width:double.infinity ,
    child: ElevatedButton(
  style: ButtonStyle(
    elevation: MaterialStateProperty.all(5.0),
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide.none,
      ),
    ),
    backgroundColor: MaterialStateProperty.all(Colors.white),
  ),
  onPressed: _registerUser,
  child: Text(
    'REGISTER',
    style: TextStyle(
      color: Color(0xff5ac18e),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
)
  );

 }

  Widget buildLoginLink(BuildContext context) {
  return GestureDetector(
    onTap: () {
     Get.toNamed(Apppage.login);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Already have an account? ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Text(
          "Log In",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}

}
