import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:instagram_clone_2/firebase-services/auth.dart';
import 'package:instagram_clone_2/materials/colors.dart';
import 'package:instagram_clone_2/materials/constant.dart';
import 'package:instagram_clone_2/materials/snackbar.dart';
import 'package:instagram_clone_2/responsive/mobile.dart';
import 'package:instagram_clone_2/responsive/responsive.dart';
import 'package:instagram_clone_2/responsive/web.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_2/screens/sign-in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? screenWidth * .3 : 44,
            vertical: 44),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: SvgPicture.asset(
                    "assets/imgs/instagram.svg",
                    width: 77,
                    height: 77,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Sign up to see photos and videos from your friends.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              return value!.isEmpty ? "can not be empty" : null;
                            },
                            controller: usernameController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: Colors.black),
                            decoration: customInputDecoration.copyWith(
                              fillColor: fillColor,
                              hintText: "Username ",
                              hintStyle: const TextStyle(color: hintColor),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            validator: (value) {
                              return value!.isEmpty ? "can not be empty" : null;
                            },
                            controller: fullNameController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: Colors.black),
                            decoration: customInputDecoration.copyWith(
                              fillColor: fillColor,
                              hintText: "Full Name ",
                              hintStyle: const TextStyle(color: hintColor),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              return value != null &&
                                      !EmailValidator.validate(value)
                                  ? "please enter a valid email"
                                  : null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: customInputDecoration.copyWith(
                              fillColor: fillColor,
                              hintText: "Email ",
                              hintStyle: const TextStyle(
                                color: hintColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: Colors.black),
                            validator: (value) {
                              return value!.length < 8
                                  ? "password should be 8 length"
                                  : null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: customInputDecoration.copyWith(
                              fillColor: fillColor,
                              hintText: "Password",
                              hintStyle: const TextStyle(color: hintColor),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      //making a spilt folder that will have a firebase auth functions first is the sign up method :)
                      AuthFirebaseMethods().signUp(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context,
                          username: usernameController.text +
                              fullNameController.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Responsive(
                                  myMobileScreen: MobileScreen(),
                                  myWebScreen: WebScreen())));
                    } else {
                      showSnackBar(context, "Something wrong try later");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: signColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth > 600 ? 100 : 90,
                          vertical: screenWidth > 600 ? 20 : 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text("Sign up"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account?",
                      style: TextStyle(
                        color: hintColor,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignIn()));
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
