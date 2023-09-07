import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:user_currentlocation_test/firebase_helper/token_service.dart';
import 'package:user_currentlocation_test/services/notification_service.dart';
import 'package:user_currentlocation_test/utils/helper_class.dart';
import 'package:user_currentlocation_test/screens/auth/login_screen.dart';
import 'package:user_currentlocation_test/screens/main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  NotificationServices notificationService = NotificationServices();
  TokenService firebaseHelper=TokenService();
  final FirebaseFirestore firestore=FirebaseFirestore.instance;

  @override
  void initState() {
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        checkUserStatus();
        notificationService.requestNotificationPermission();
         notificationService.getDeviceToken();
        notificationService.foregroundMessage();
        notificationService.setupInteractMessage(context);
        notificationService.firebaseInit(context);
      });
    }
    super.initState();

  }


  Future<void> checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      kNavigation(context: context, screen: const MainScreen());
    }else{
      kNavigation(context: context, screen: const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator while checking user status
      ),
    );
  }
}
