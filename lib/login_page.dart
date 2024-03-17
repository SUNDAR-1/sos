import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:women_safety_app/signup_page.dart';
import 'package:women_safety_app/routes/routes.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget{

  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithEmailAndPassword() async {

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email and password cannot be empty.'),
      ),
    );
    return; // Exit the function early if fields are empty
  }

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final User? user = userCredential.user;

      if (user != null) {
        
        Get.offNamed(Apppage.navbar);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
      }
    } catch (e) {
      String errorMessage =
          "An error occurred. Please try again."; 
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Invalid password.';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }
  bool isRememberMe = false;

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
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
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
       controller: passwordController,
        obscureText: true,
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

Widget buildForgotpassBtn(){
  return Container(
    alignment: Alignment.centerRight,
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.only(right:0)
      ),
      onPressed: ()=> print("Forgot Password pressed"),
      
      child:Text(
        'Forgot Passsword?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      )
    ),
    );
}

Widget buildRememberCb(){

  return Container(
    height: 20,
    child: Row(
      children: <Widget> [
        Theme(data: ThemeData(unselectedWidgetColor: Colors.white),
         child: Checkbox(
          value: isRememberMe,
          checkColor: Colors.green,
          activeColor: Colors.white,
          onChanged: (value) {
            setState(() {
              isRememberMe = value!;
            });
          },
        ),
      ),
      Text(
        'Remember me',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      )
      ]
    )
  );
}
Widget buildLoginbtn(){
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
  onPressed: () {
    _signInWithEmailAndPassword();
   
  },
  child: Text(
    'LOGIN',
    style: TextStyle(
      color: Color(0xff5ac18e),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
)
  );

 }

Widget buildSignupbtn() {
  
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignupPage()));
      },
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: 'Don\'t have an Account? ',
            style: TextStyle(color: Colors.white, fontSize:18,fontWeight: FontWeight.w500)),
        TextSpan(
            text: 'Sign Up',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
      ])),
    );
    

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                 height: double.infinity,
                 width: double.infinity,
                 decoration: BoxDecoration(
                  gradient: LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                    colors: [
                      Color(0xfff48fb1),
                      Color(0xFFF06292),
                      Color(0xFFEC407A),
                      Color(0XFFE91E63),
                    ]
                 )
               ),
               child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 120
                ),
                         child: Column(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                  ), 
                  SizedBox(height: 50),
                  buildEmail(),
                  SizedBox(height: 20),
                  buildPassword(),
                  buildForgotpassBtn(),
                  buildRememberCb(),
                  buildLoginbtn(),
                  buildSignupbtn(),
                  
                ],
               )
               )
              )
           ],
          ),
        ),
      ),
    );
  }
}