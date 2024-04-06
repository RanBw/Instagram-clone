import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_2/materials/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isloading = true;
  Map userData = {};

  int followers = 0;
  int following = 0;
  int posts = 0;

  getDataFromFirestore() async {
    setState(() {
      isloading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

      userData = userDataSnapshot.data()!;
      followers = userData["followers"].length;
      following = userData["following"].length;

      var postsDataSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      posts = postsDataSnapshot.docs.length;
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

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return isloading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
        : Scaffold(
            backgroundColor: widthScreen < 600 ? mobileBackgroundColor : null,
            appBar: widthScreen < 600
                ? AppBar(
                    backgroundColor: mobileBackgroundColor,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 0),
                      child: Text(userData["username"].toString()),
                    ),
                  )
                : null,
            body: Container(
              decoration: BoxDecoration(
                color: widthScreen > 600 ? mobileBackgroundColor : null,
                borderRadius:
                    widthScreen > 600 ? BorderRadius.circular(10) : null,
              ),
              margin: widthScreen > 600
                  ? EdgeInsets.symmetric(
                      vertical: 50, horizontal: widthScreen / 4)
                  : null,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        widthScreen < 600
                            ? const Text("")
                            : Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      userData["username"],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundImage: NetworkImage(userData["pfp"]),
                            ),
                            SizedBox(width: widthScreen < 600 ? 45 : 0),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      posts.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text(
                                      "Post",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 189, 196, 199),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                // Sized
                                Column(
                                  children: [
                                    Text(followers.toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text(
                                      "Followers",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 189, 196, 199),
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    Text(following.toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Text("Following",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 189, 196, 199),
                                            fontSize: 15))
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Best developer ever exist",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 0.08,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                                style: ButtonStyle(
                                  side: const MaterialStatePropertyAll(
                                      BorderSide(
                                          color: Color.fromARGB(
                                              109, 255, 255, 255),
                                          style: BorderStyle.solid)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(0, 90, 103, 223)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: widthScreen > 600 ? 18 : 10,
                                          horizontal: 33)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7))),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                                label: const Text("Edit Profile")),
                            const SizedBox(
                              width: 14,
                            ),
                            ElevatedButton.icon(
                                style: ButtonStyle(
                                  side: const MaterialStatePropertyAll(
                                      BorderSide(
                                          color: Color.fromARGB(
                                              109, 255, 255, 255),
                                          style: BorderStyle.solid)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(0, 90, 103, 223)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: widthScreen > 600 ? 18 : 10,
                                          horizontal:
                                              widthScreen > 600 ? 44 : 33)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7))),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.logout),
                                label: const Text("Logout")),
                          ],
                        )
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where("uid",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }

                        return Expanded(
                          child: Padding(
                            padding: widthScreen > 600
                                ? const EdgeInsets.all(20.0)
                                : const EdgeInsets.all(3.0),
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 2 / 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            widthScreen > 600 ? 30 : 10)),
                                    child: Image.network(
                                      snapshot.data!.docs[index]["imgPost"],
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }),
                          ),
                        );
                      })
                ],
              ),
            ),
          );
  }
}
