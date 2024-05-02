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
  await Firebase.initializeApp();
      runApp(MyAPP()as Widget);
}

class MyAPP extends StatelessWidget {
  final AuthC = Get.put(LoginController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: AuthC.streamAuthStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            print(snapshot);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Application",
              initialRoute:
                   snapshot.data != null && snapshot.data!.emailVerified == true
                      ? Routes.HOME
                      : Routes.LOGIN,
              getPages: AppPages.routes,
              theme: ThemeData(
                primarySwatch: Colors.indigo,
              ),
            );
          }
          return SplashscreenView();
        });
  }
  
}

