import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_2/firebase-services/firestore.dart';
import 'package:instagram_clone_2/materials/colors.dart';

import 'package:instagram_clone_2/responsive/mobile.dart';
import 'package:instagram_clone_2/responsive/responsive.dart';
import 'package:instagram_clone_2/responsive/web.dart';

import 'package:path/path.dart' show basename;

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isloading = true;
  Map userData = {};

  int followers = 0;
  int following = 0;
  final captionController = TextEditingController();

  getDataFromFirestore() async {
    setState(() {
      isloading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = snapshot.data()!;
      followers = userData["followers"].length;
      following = userData["following"].length;
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromFirestore();
  }

  Uint8List? imgPath;
  //Global Variable so we can use it everywhere
  String? imgName;

  bool isLoading = false;

  // String? url;
  uploadImg(ImageSource source) async {
    final XFile? pickedImg = await ImagePicker().pickImage(source: source);

    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();
        setState(() {
          // imgPath = File(pickedImg.path);
          // secondPage = true;
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {}
    } catch (e) {
      print(e);
    }
  }

  showmodel() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  uploadImg(ImageSource.camera);
                  Navigator.pop(context);
                },
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Icon(Icons.camera),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  uploadImg(ImageSource.gallery);
                  Navigator.pop(context);
                },
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Icon(Icons.photo),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "From Gallary",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return imgPath != null
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      imgPath = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
              actions: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await FirestoreMethods().uploudPost(
                          profileImg: userData["pfp"],
                          username: userData["username"],
                          description: captionController.text,
                          uid: FirebaseAuth.instance.currentUser!.uid,
                          datePublished: DateTime.now(),
                          context: context,
                          imgName: imgName,
                          imgPath: imgPath);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Responsive(
                                  myMobileScreen: MobileScreen(),
                                  myWebScreen: WebScreen())));
                    },
                    child: const Text(
                      "Post",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                isLoading
                    ? const LinearProgressIndicator()
                    : const Divider(
                        thickness: 1,
                      ),
                Row(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CircleAvatar(
                      radius: 33,
                      backgroundImage: NetworkImage(userData["pfp"]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      controller: captionController,
                      decoration:
                          const InputDecoration(hintText: "type anything..."),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: 66,
                        height: 74,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(imgPath!),
                                fit: BoxFit.cover)))
                  ],
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            // appBar: AppBar(
            //   title: Text("AddPost"),
            // ),

            body: Center(
                child: IconButton(
              onPressed: () async {
                await showmodel();
              },
              icon: Icon(
                Icons.upload,
                size: widthScreen < 600 ? 55 : 55,
              ),
            )),
          );
  }
}
