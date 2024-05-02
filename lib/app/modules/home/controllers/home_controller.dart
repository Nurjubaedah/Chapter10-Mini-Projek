import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // tambahkan ini

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final picker = ImagePicker(); // tambahkan ini

  // Variabel untuk menyimpan data pengguna
  var userName = ''.obs;
  var phoneNumber = ''.obs;
  var address = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Memanggil metode untuk mendapatkan data pengguna ketika HomeController diinisialisasi
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      // Mengambil pengguna saat ini dari Firebase Authentication
      User? user = _auth.currentUser;

      if (user != null) {
        // Menggunakan ID pengguna untuk mengambil data pengguna dari Firestore
        DocumentSnapshot userSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (userSnapshot.exists) {
          // Mendapatkan data pengguna dari Firestore
          Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            // Memperbarui variabel data pengguna
            userName.value = userData['name'] ?? '';
            phoneNumber.value = userData['phoneNumber'] ?? '';
            address.value = userData['address'] ?? '';
          }
        }
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<void> uploadPhoto(String imagePath) async {
    try {
      // Upload foto ke Cloud Firestore
      var photoRef = _firestore.collection('photos').doc();
      await photoRef.set({'url': imagePath});
      
      // Tampilkan pesan sukses
      Get.snackbar(
        'Success',
        'Photo uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(12),
      );
    } catch (e) {
      print('Error uploading photo: $e');
      // Tampilkan pesan error jika terjadi masalah saat mengunggah foto
      Get.snackbar(
        'Error',
        'Failed to upload photo. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(12),
      );
    }
  }

  // Fungsi untuk menambahkan atau memperbarui foto profil
  void addOrUpdatePhoto() async {
    try {
      // Memilih foto dari perangkat pengguna
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Jika pengguna memilih foto, upload foto ke Cloud Firestore
        final imagePath = pickedFile.path;
        await uploadPhoto(imagePath);
      }
    } catch (e) {
      print('Error picking image: $e');
      // Tampilkan pesan error jika terjadi masalah saat memilih foto
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
