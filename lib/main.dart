import 'package:mini_project_application/app/modules/login/controllers/login_controller.dart';
import 'package:mini_project_application/app/modules/splashscreen/views/splashscreen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyADBKQEgXNBZzNp0EAJXbLCHLrNMCvQggM", 
      appId: "1:655353746643:android:f081758c902f6b5ffcb026", 
      messagingSenderId: "655353746643", 
      projectId: "mini-project-app-1a1f3",
      ),
  );
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: Routes.SPLASHSCREEN,
      getPages: AppPages.routes,
    ),
  );
      
}

  



