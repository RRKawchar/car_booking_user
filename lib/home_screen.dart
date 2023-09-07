// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:user_currentlocation_test/firebase_helper/auth_service.dart';
import 'package:user_currentlocation_test/provider/location_provider.dart';
import 'package:user_currentlocation_test/utils/text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String address;
  Placemark placemark= Placemark();
  @override
  void initState() {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    super.initState();
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_){
        provider.getLocation(context);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            AuthService.signOut(context);
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<LocationProvider>(
            builder: (context, value, child) {
              return Text(
                value.placemark.country !=null?
                value.placemark.country.toString():"Loading....",
                style: AppTextStyle.normalTextStyle(
                  fontSize: 30,
                ),
              );
            },
          ),

          Center(
            child: ElevatedButton(
              onPressed: () {
                if (placemark.country.toString()=='United States'){

                  print("You can Login");

                }else{

                  print("Invalid users");

                }

                //getLocation();
              },
              child: const Text("next"),
            ),
          ),
        ],
      ),
    );
  }
}
