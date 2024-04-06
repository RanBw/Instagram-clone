import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_2/firebase-services/storage.dart';
import 'package:instagram_clone_2/materials/snackbar.dart';
import 'package:instagram_clone_2/models/post.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  uploudPost(
      {required profileImg,
      required username,
      required description,
      required uid,
      required datePublished,
      required context,
      required imgName,
      required imgPath}) async {
    try {
      var uuid = const Uuid().v1();

      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');
      String URL = await getImgURL(
          imgName: imgName,
          imgPath: imgPath,
          folderName: 'ImgPosts/${FirebaseAuth.instance.currentUser!.uid}');
      Post post = Post(
          profileImg: profileImg,
          username: username,
          description: description,
          imgPost: URL,
          uid: uid,
          postId: uuid,
          datePublished: datePublished,
          likes: []);
      await posts
          .doc(uuid)
          .set(post.convert2Map())
          .then((value) => print("Post Added"))
          .catchError((error) => print("Failed to add post: $error"));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "Error : ${e.code}");
    } catch (e) {
      print(e);
    }
  }

  uploudComment(
      {required uid,
      required commentId,
      required pfp,
      required username,
      required controller,
      required postId}) async {
    if (controller.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .set({
        "profileImg": pfp,
        "username": username,
        "textComment": controller.text,
        "datePublished": DateTime.now(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "commentId": commentId
      });
    } else {
      print("emptyyy");
    }
  }
}
