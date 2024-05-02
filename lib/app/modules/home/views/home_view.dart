import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project_application/app/modules/home/controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  final HomeController controller = Get.find();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/Bg-HomeScreen.png',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hello, ${userData['name']}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.account_circle),
                      ],
                    ),
                    SizedBox(height: 4), // Jarak antara teks "Hello" dan "How your day going"
                    Text('How\'s your day going'),
                    SizedBox(height: 8), // Jarak antara teks dan garis
                    Divider(height: 1, color: Colors.black38), // Garis pemisah
                    SizedBox(height: 8), // Jarak antara garis dan teks berikutnya

                    Text('My Phone Number: ${userData['phoneNumber']}'),
                    Text('My Address: ${userData['address']}'),
                    SizedBox(height: 20), // Jarak antara tombol dengan teks berikutnya
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 190, 66, 149),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            // Jika pengguna memilih foto, upload foto ke Cloud Firestore
                            controller.uploadPhoto(pickedFile.path);
                          }
                        },
                        child: Text('Upload Photo'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
