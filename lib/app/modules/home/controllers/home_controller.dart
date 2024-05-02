import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();

  var userName = ''.obs;
  var phoneNumber = ''.obs;
  var address = ''.obs;
  var profilePhotoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (userSnapshot.exists) {
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            userName.value = userData['name'] ?? '';
            phoneNumber.value = userData['phoneNumber'] ?? '';
            address.value = userData['address'] ?? '';

            String? photoUrl = userData['photoUrl'];
            if (photoUrl != null && photoUrl.isNotEmpty) {
              profilePhotoUrl.value = photoUrl;
            }
          }
        }
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<void> uploadPhoto(String imagePath) async {
    try {
      var photoRef = _firestore.collection('photos').doc();
      await photoRef.set({'url': imagePath});

      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'photoUrl': imagePath,
      });

      profilePhotoUrl.value = imagePath;

      Get.snackbar(
        'Success',
        'Photo uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(12),
      );
    } catch (e) {
      print('Error uploading photo: $e');
      Get.snackbar(
        'Error',
        'Failed to upload photo. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(12),
      );
    }
  }

  void addOrUpdatePhoto() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imagePath = pickedFile.path;
        await uploadPhoto(imagePath);
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(12),
      );
    }
  }
}