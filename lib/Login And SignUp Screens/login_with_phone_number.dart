import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Login%20And%20SignUp%20Screens/login.dart';
import 'package:fyp/Login%20And%20SignUp%20Screens/phone_number_verification.dart';
import 'package:fyp/Login%20And%20SignUp%20Screens/signup.dart';
import 'package:fyp/Utils/toast.dart';

import '../Components/button.dart';
import '../Components/textfield.dart';

class LoginWithPhoneNumberScreen extends StatefulWidget {
  const LoginWithPhoneNumberScreen({super.key});

  @override
  State<LoginWithPhoneNumberScreen> createState() =>
      _LoginWithPhoneNumberScreenState();
}

class _LoginWithPhoneNumberScreenState extends State<LoginWithPhoneNumberScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  //final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
    //passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
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
                          controller: phoneNumberController,
                          labelText: "Phone Number",
                          color: Colors.white,
                          textStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.phone_android_outlined,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: height * 0.03),
                      ],
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
                          setState(() {
                            loading = true;
                          });
                          _auth.verifyPhoneNumber(
                              phoneNumber: phoneNumberController.text,
                              verificationCompleted: (_) {
                                setState(() {
                                  loading = false;
                                });
                              },
                              verificationFailed: (error) {
                                setState(() {
                                  loading = false;
                                });
                                FlutterToastMessage.toastMessage(
                                    error.toString());
                              },
                              codeSent: (String verificationId, int? token) {
                                setState(() {
                                  loading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NumberVerificationScreen(verificationId: verificationId)));
                              },
                              codeAutoRetrievalTimeout: (error) {
                                setState(() {
                                  loading = false;
                                });
                                FlutterToastMessage.toastMessage(
                                    error.toString());
                              });
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
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
                    height: height * 0.01,
                  ),
                  CustomButton(
                      title: "Login With Email",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
