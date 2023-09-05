import 'package:flutter/widgets.dart';
import 'package:user_currentlocation_test/home_screen.dart';
import 'package:user_currentlocation_test/screens/booking/booking_scren.dart';

class MainProvider with ChangeNotifier{

  final List<Widget> _pages=[

    HomeScreen(),
    BookingScreen(),
    Text("Profile"),

  ];

  List<Widget> get pages=>_pages;

  int currentPageIndex = 0;

  void onDestination(int index){
   currentPageIndex=index;
   notifyListeners();
  }

  }