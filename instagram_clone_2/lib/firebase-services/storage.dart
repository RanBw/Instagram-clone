import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

getImgURL(
    {required String imgName,
    required Uint8List imgPath,
    required String folderName}) async {
  final storageRef = FirebaseStorage.instance.ref("$folderName/$imgName");

  UploadTask uploadTask = storageRef.putData(imgPath);
  TaskSnapshot snap = await uploadTask;

  String url = await snap.ref.getDownloadURL();

  return url;
}
