import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/Components/button.dart';
import 'package:fyp/Components/textfield.dart';
import 'package:fyp/Login%20And%20SignUp%20Screens/login_with_phone_number.dart';
import 'package:fyp/Screens/home_Screen.dart';
import 'package:fyp/Login%20And%20SignUp%20Screens/signup.dart';

import '../Utils/toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
   @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void login(){
     setState(() {
       loading = true;
     });
     String email = emailController.text.toString();
     String pass = passwordController.text.toString();
    _auth.signInWithEmailAndPassword(email: email, password: pass).then((value){
      FlutterToastMessage.toastMessage(value.user!.email.toString());
      setState(() {
        loading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
    }).catchError((error){
      String errorMessage = "An error occured while logging in. Please Try Again...";
      if (error is FirebaseAuthException){
        switch(error.code){
          case 'wrong-password':
            errorMessage = "Incorrect Password. Please Try Again.";
            break;
          case 'user-not-found':
            errorMessage = "User Not Found. Please Sign Up.";
            break;
          default:
            break;
        }
      }
      FlutterToastMessage.toastMessage(errorMessage);
      setState(() {
        loading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    // willpopScope use for (if you click on the mobile back button the app will close)
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: height * 0.15),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Welcome Back!",
                          style: TextStyle(color: Colors.black, fontSize: 26),
                        )),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    const Text(
                      "Login To Your Account",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: Column(
                  children: [
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: emailController,
                            labelText: "Email",
                            color: Colors.white,
                            textStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: height * 0.03),
                          CustomTextField(
                            controller: passwordController,
                            labelText: "Password",
                            color: Colors.white,
                            textStyle: const TextStyle(color: Colors.black),
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassField: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter Password";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        child: const Text("Forgot Password?"),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    CustomButton(
                      loading: loading,
                        title: "Login",
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            login();
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpScreen()));
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.transparent),
                          ),
                          child: const Text("Sign Up"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height *0.01,
                    ),
                    CustomButton(
                        title: "Login With Phone No",
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginWithPhoneNumberScreen()));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
