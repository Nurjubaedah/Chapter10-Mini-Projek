import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_project_application/app/routes/app_pages.dart';
import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), (() {
      Get.offAllNamed(Routes.LOGIN); 
    }));
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bgsplash.png', 
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 91.83,
            bottom: 273.92,
            child: Center(
              child: Image.asset(
                'assets/images/bunga-ungu.png',
                width: 229.51,
                height: 149.8,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 385,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  text: "HELLO FELLAS.\n",
                  children: [
                    TextSpan(
                      text: "Temukan segala jenis bunga\n dari berbagai belahan dunia",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
