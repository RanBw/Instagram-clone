import 'package:flutter/material.dart';
import 'package:instagram_clone_2/firebase-services/auth.dart';
import 'package:instagram_clone_2/materials/colors.dart';
import 'package:instagram_clone_2/materials/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_2/screens/sign-up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Form(
                      child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: emailController,
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
                        style: const TextStyle(color: Colors.black),
                        controller: passwordController,
                        decoration: customInputDecoration.copyWith(
                          suffixIcon: const Icon(
                            Icons.visibility_outlined,
                            color: secondaryColor,
                          ),
                          fillColor: fillColor,
                          hintText: "Password",
                          hintStyle: const TextStyle(color: hintColor),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: const SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.end,
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await AuthFirebaseMethods().signIn(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: signColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth > 600 ? 100 : 90,
                                vertical: screenWidth > 600 ? 20 : 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text("Sign In"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't Have an account?",
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
                                        builder: (context) => const SignUp()));
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ))
                        ],
                      )
                    ],
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
