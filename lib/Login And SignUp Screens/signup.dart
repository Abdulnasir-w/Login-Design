import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Components/button.dart';
import 'package:fyp/Components/textfield.dart';
import 'package:fyp/Login%20And%20SignUp%20Screens/login.dart';
import 'package:fyp/Utils/toast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void signup(){
    setState(() {
      loading = true;
    });
    String email = emailController.text.toString();
    String pass = passwordController.text.toString();
    _auth.createUserWithEmailAndPassword(email: email, password: pass).then((value){
      setState(() {
        loading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
    }).catchError((error){
      String errorMessage = "An error occurred while signing up. Please try again.";
      if (error is FirebaseAuthException){
        switch(error.code){
          case 'email-already-in-use':
            errorMessage = "This email is already in use. Please use a different one.";
            break;
          case 'invalid-email':
            errorMessage = "Invalid email address. Please check your email format..";
            break;
          case 'weak-password':
            errorMessage = "Password is too Weak. Please choose a Strong Password.";
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
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: height * 0.15),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Register",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: height * 0.02),
            const Text(
              "Create Your Account",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: height * 0.05),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          labelText: "Username",
                          color: Colors.white,
                          textStyle: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.name,
                          prefixIcon: Icons.person_2_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter UserName";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: height * 0.03),
                        CustomTextField(
                          controller: emailController,
                          labelText: "Phone No or Email",
                          color: Colors.white,
                          textStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Phone No or Email";
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
                        SizedBox(height: height * 0.03),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  CustomButton(title: "SignUP",loading: loading, onPressed: () {
                    if(_formKey.currentState!.validate()){
                      signup();
                    }
                  },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
