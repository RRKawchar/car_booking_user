import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:user_currentlocation_test/components/custom_button.dart';
import 'package:user_currentlocation_test/components/custom_textfield.dart';
import 'package:user_currentlocation_test/firebase_helper/booking_service.dart';
import 'package:user_currentlocation_test/firebase_helper/token_service.dart';
import 'package:user_currentlocation_test/services/notification_service.dart';
import 'package:user_currentlocation_test/utils/helper_class.dart';
import 'package:http/http.dart'as http;

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();
  final picUpController = TextEditingController();
  final dropOffController = TextEditingController();
  NotificationServices notificationServices=NotificationServices();
  var deviceToken;



  @override
  void initState() {

    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_){
       fetchUserData();
       getDeviceToken();
      });
    }
    super.initState();
  }


  Future<void> getDeviceToken()async{
    deviceToken =await notificationServices.getDeviceToken();
  }


  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateController.dispose();
    picUpController.dispose();
    dropOffController.dispose();
    super.dispose();
  }

Future<void>fetchUserData()async{


    try{

      final user =FirebaseAuth.instance.currentUser;
      if(user !=null){

        final userDoc=await FirebaseFirestore.instance.collection("passenger").doc(user.uid).get();
        if(userDoc.exists){
          final userData= userDoc.data() as Map<String,dynamic>;

          nameController.text=userData['name']??'';
          emailController.text=userData['email']??'';
          phoneController.text=userData['phone']??'';
        }
      }


    }catch(e){
      kPrint(e.toString());
    }

}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Booking"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextField(
                labelText: "Full Name",
                controller: nameController,
              ),
              kSizedBox(height: 10),
              CustomTextField(
                labelText: "Email",
                controller: emailController,
              ),
              kSizedBox(height: 10),
              CustomTextField(
                labelText: "Phone",
                controller: phoneController,
              ),
              kSizedBox(height: 10),
              CustomTextField(
                labelText: "Date",
                controller: dateController,
              ),
              kSizedBox(height: 10),
              CustomTextField(
                labelText: "Pick up Location",
                controller: picUpController,
              ),
              kSizedBox(height: 10),
              CustomTextField(
                labelText: "Drop off location",
                controller: dropOffController,
              ),
              kSizedBox(height: 20),
              CustomButton(
                  onPressed: () {
                    BookingService.bookingPassenger(
                      deviceToken: deviceToken,
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      date: dateController.text,
                      picLocation: picUpController.text,
                      dropLocation: dropOffController.text,
                      context: context,
                    );
                    sendBooking();
                  },
                  text: "Send",)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendBooking() async {
    try {
   var adminDeviceTokens= await TokenService.getAdminDeviceTokens();
          print(" Admin DeviceToken : $adminDeviceTokens");
      if (adminDeviceTokens.isNotEmpty) {
        var body = {
          'registration_ids': adminDeviceTokens, // Use 'registration_ids' for multiple devices.
          'priority': 'high',
          'notification': {
            'title': "New Reservation Request From",
            'body':nameController.text,

          },
          'data': {
            'type': 'message',
            'id': 'rrk123',
            'image':
            'https://cdn2.vectorstock.com/i/1000x1000/23/91/small-size-emoticon-vector-9852391.jpg',
            'name':nameController.text,
            'phone':phoneController.text,
            "date": dateController.text,
            "email": emailController.text,
            "deviceToken": deviceToken,
            'dropLocation': dropOffController.text,
            'pickUpLocation':picUpController.text
          },
          "category": "News"
        };

        var headers = {
          "Content-Type": "application/json",
          "Authorization":
          "key=AAAAD6BSupQ:APA91bFDMrMe-ELTtMAuL3-N-3xuyqHE_xFJWNbz7Xm_q4FeMxa1nUnWo0TpmRoHQi7uAuMLAfncbqVXBryFsWFs32kD5QhqxaVIYg0XlMrL_Mt1R2wDOvrfOLLhtmXKdq8A1-O5-J4z"
        };

        var response = await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          body: jsonEncode(body),
          headers: headers,
        );

        if (response.statusCode == 200) {
          print("Notification sent successfully!");
        } else {
          print("Failed to send notification. Status code: ${response.statusCode}");
        }
      } else {
        print("Device tokens are empty. Cannot send notification.");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

}
