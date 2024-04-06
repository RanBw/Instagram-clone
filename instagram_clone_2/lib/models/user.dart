import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String email;
  String password;
  String uid;
  String username;
  String pfp;
  List followers;
  List following;

  UserData(
      {required this.email,
      required this.password,
      required this.uid,
      required this.username,
      required this.pfp,
      required this.followers,
      required this.following});

  Map<String, dynamic> convert2Map() {
    return {
      'email': email,
      'password': password,
      'uid': uid,
      'username': username,
      'pfp': pfp,
      'followers': followers,
      'following': following
    };
  }

  // function that convert "DocumentSnapshot" to a User
// function that takes "DocumentSnapshot" and return a User

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
      email: snapshot["email"],
      username: snapshot["username"],
      password: snapshot["password"],
      uid: snapshot["uid"],
      pfp: snapshot["pfp"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }
}
