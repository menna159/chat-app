import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

Future<String?> pickAndUploadImage(String userId) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final fileBytes = await pickedFile.readAsBytes();
        final storageRef =
            FirebaseStorage.instance.ref().child('profile_images/$userId.png');

        final uploadTask = storageRef.putData(fileBytes);
        await uploadTask;

        final imageUrl = await storageRef.getDownloadURL();
        return imageUrl;
      } else {
        File file = File(pickedFile.path);
        final storageRef =
            FirebaseStorage.instance.ref().child('profile_images/$userId.png');

        final uploadTask = storageRef.putFile(file);
        await uploadTask;

        // Get the download URL
        final imageUrl = await storageRef.getDownloadURL();
        return imageUrl;
      }
    }
  } catch (e) {
    // print('Error picking or uploading image: $e');
  }
  return null;
}
