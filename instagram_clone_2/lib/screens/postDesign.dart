import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_2/materials/colors.dart';
import 'package:instagram_clone_2/screens/addComment.dart';
import 'package:intl/intl.dart';

class PostDesign extends StatefulWidget {
  final Map<String, dynamic> data;

  const PostDesign({required this.data, super.key});

  @override
  State<PostDesign> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  int commentCount = 0;
  bool isLoading = true;
  bool heart = false;
  getCommentCounts() async {
    QuerySnapshot commentList = await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.data["postId"])
        .collection("comments")
        .get();
    setState(() {
      commentCount = commentList.docs.length;
    });
  }

  showmodel() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              FirebaseAuth.instance.currentUser!.uid == widget.data["uid"]
                  ? SimpleDialogOption(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("posts")
                            .doc(widget.data["postId"])
                            .delete();
                      },
                      padding: const EdgeInsets.all(20),
                      child: const Row(
                        children: [
                          Icon(Icons.camera),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Delete Post",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    )
                  : SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.all(11),
                      child: const Row(
                        children: [
                          Icon(Icons.camera),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "You can not delete this post",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
              SimpleDialogOption(
                onPressed: () {
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
                      "Cancel",
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MediaQuery.of(context).size.width > 600
            ? mobileBackgroundColor
            : mobileBackgroundColor,
        borderRadius: MediaQuery.of(context).size.width > 600
            ? BorderRadius.circular(10)
            : null,
      ),
      margin: MediaQuery.of(context).size.width > 600
          ? EdgeInsets.symmetric(
              vertical: 20, horizontal: MediaQuery.of(context).size.width / 4)
          : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            NetworkImage(widget.data["profileImg"]),
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                      Text(
                        widget.data["username"],
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () async {
                        await showmodel();
                      },
                      icon: const Icon(Icons.more_vert))
                ]),
          ),
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
            child: Image.network(
              widget.data["imgPost"],
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("posts")
                              .doc(widget.data["postId"])
                              .update({
                            "likes": [FirebaseAuth.instance.currentUser!.uid]
                          });

                          setState(() {
                            heart = true;
                          });
                        },
                        icon: widget.data["likes"].contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(Icons.favorite_border)),
                    IconButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddComment(data: widget.data)));
                        },
                        icon: const Icon(Icons.comment_outlined)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border_outlined)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: Text(
                      "${widget.data["likes"].length} ${widget.data["likes"].length > 1 ? "Likes" : "Like"}",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 189, 196, 199)),
                    )),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      MediaQuery.of(context).size.width > 600
                          ? Text(
                              widget.data["username"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : Text(
                              widget.data["username"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width > 600 ? 20 : 6,
                      ),
                      MediaQuery.of(context).size.width > 600
                          ? Text(
                              widget.data["description"],
                              style: const TextStyle(fontSize: 14),
                            )
                          : Text(
                              widget.data["description"],
                              style: const TextStyle(fontSize: 14),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddComment(data: widget.data)));
                  },
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "view all $commentCount comments",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 189, 196, 199)),
                      )),
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                    width: double.infinity,
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.data["datePublished"].toDate()),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 189, 196, 199)),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
