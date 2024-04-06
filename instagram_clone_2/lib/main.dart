import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:instagram_clone_2/firebase_options.dart';
import 'package:instagram_clone_2/materials/snackbar.dart';

import 'package:instagram_clone_2/responsive/mobile.dart';
import 'package:instagram_clone_2/responsive/responsive.dart';
import 'package:instagram_clone_2/responsive/web.dart';
import 'package:instagram_clone_2/screens/sign-in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const Root());
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        } else if (snapshot.hasError) {
          return showSnackBar(context, "Something went wrong");
        } else if (snapshot.hasData) {
          return const Responsive(
            myMobileScreen: MobileScreen(),
            myWebScreen: WebScreen(),
          );
        } else {
          return const SignIn();
        }
      },
    );
  }
}
