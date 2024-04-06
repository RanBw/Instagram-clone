import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_2/materials/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone_2/screens/postDesign.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:
            widthScreen > 600 ? mobileBackgroundColor : mobileBackgroundColor,
        appBar: widthScreen < 600
            ? AppBar(
                backgroundColor: mobileBackgroundColor,
                title: SvgPicture.asset(
                  "assets/imgs/instagram.svg",
                  width: 55,
                  height: 40,
                  color: Colors.white,
                ),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message_rounded)),
                  IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.logout)),
                ],
              )
            : null,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                data = document.data()! as Map<String, dynamic>;
                return PostDesign(data: data);
              }).toList(),
            );
          },
        ));
  }
}
