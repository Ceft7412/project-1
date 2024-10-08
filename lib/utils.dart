import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> getImageFromGallery(BuildContext context) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print(pickedFile.path);
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<String?> uploadFileForUser(File file) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final fileName = file.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef = storageRef.child("$userId/uploads/$timestamp-$fileName");
    await uploadRef.putFile(file);
    final downloadURL = await uploadRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print(e);
  }
  return null;
}
