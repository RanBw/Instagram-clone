import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_2/materials/colors.dart';
import 'package:instagram_clone_2/screens/show-user.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // هذا عشان وقت ما ابحث عن اليوزر هو يطلع لي لكن ما ينعرض على الشاشة الا اذا سوينا سيت ستيت عشان يقرا الكود من اول وجديد
    myController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: myController,
          decoration: const InputDecoration(labelText: "search for a user..."),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where("username", isEqualTo: myController.text)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowUserPage(
                                    username: myController.text,
                                  )));
                    },
                    title: Text(snapshot.data!.docs[index]["username"]),
                    leading: CircleAvatar(
                      radius: 33,
                      backgroundImage: NetworkImage(
                          // "https://i.pinimg.com/564x/94/df/a7/94dfa775f1bad7d81aa9898323f6f359.jpg"
                          snapshot.data!.docs[index]["pfp"]),
                    ),
                  );
                });
          }

          return const CircularProgressIndicator(
            color: Colors.white,
          );
        },
      ),
    );
  }
}
