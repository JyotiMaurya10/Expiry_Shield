import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/get_user_data_controller.dart';
import '../../utils/app_constant.dart';
import '../admin-panel/admin_panel.dart';
import '../user-panel/main_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      loggdin(context);
    });
  }

  Future<void> loggdin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);

      if (userData[0]['isAdmin'] == true) {
        Get.offAll(() => const AdminMainScreen());
      } else {
        Get.offAll(() => const MainScreen());
      }
    } else {
      Get.to(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appSecondaryColor,
        elevation: 0,
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            width: 300,
            height: 300,
            alignment: Alignment.center,
            child: Lottie.asset('assets/images/splash_screen.json'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          width: Get.width,
          alignment: Alignment.center,
          child: Text(
            AppConstant.appPoweredBy,
            style: const TextStyle(
                color: AppConstant.appTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }
}
