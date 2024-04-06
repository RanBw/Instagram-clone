import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_2/firebase-services/firestore.dart';
import 'package:instagram_clone_2/materials/colors.dart';
import 'package:instagram_clone_2/materials/constant.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddComment extends StatefulWidget {
  final Map<String, dynamic> data;
  const AddComment({required this.data, super.key});

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final myController = TextEditingController();
  Map userData = {};
  bool isLoading = true;

  getDataFromFirestore() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

      userData = userDataSnapshot.data()!;
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text("Comments"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.data["postId"])
                      .collection("comments")
                      .orderBy("datePublished")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data11 =
                              document.data()! as Map<String, dynamic>;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          NetworkImage(data11["profileImg"]),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            data11["username"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(data11["textComment"])
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        DateFormat.yMMMd().format(
                                            data11["datePublished"].toDate()),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite)),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 11),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: CircleAvatar(
                          radius: 33,
                          backgroundImage: NetworkImage(userData["pfp"]),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: myController,
                          style: const TextStyle(color: Colors.black),
                          decoration: customInputDecoration.copyWith(
                            suffixIcon: IconButton(
                              onPressed: () async {
                                String commentId = const Uuid().v1();

                                await FirestoreMethods().uploudComment(
                                    uid: userData["uid"],
                                    commentId: commentId,
                                    pfp: userData["pfp"].toString(),
                                    username: userData["username"],
                                    controller: myController,
                                    postId: widget.data["postId"]);

                                myController.clear();
                              },
                              icon: const Icon(
                                Icons.send,
                              ),
                            ),
                            hintText: "Comment as ${userData["username"]}",
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
