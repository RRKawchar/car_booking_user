import 'dart:convert';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String phone;
  final String image;
  final String date;
  final String name;
  final String email;
  final String dropUpLocation;
  final String pickUpLocation;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.date,
    required this.name,
    required this.email,
    required this.dropUpLocation,
    required this.pickUpLocation,
    required this.phone

  });

  factory NotificationModel.fromJson(Map<String,dynamic> json){
    return NotificationModel(
      id: json['id']??'',
      title: json['title']??'',
      body: json['body']??'',
      image: json['image']??'',
      date: json['date']??'',
      name: json['name']??'',
      email: json['email']??'',
      pickUpLocation: json['pickUpLocation'] ??'',
      dropUpLocation: json['dropUpLocation']??'',
      phone: json['phone']??''
    );
  }


  Map<String,dynamic> toJson(){

    final Map<String,dynamic> jsonData=<String,dynamic>{};
    jsonData['id']=id;
    jsonData['title']=title;
    jsonData['body']=body;
    jsonData['image']=image;
    jsonData['date']=date;
    jsonData['name']=name;
    jsonData['email']=email;
    jsonData['pickUpLocation']=pickUpLocation;
    jsonData['dropUpLocation']=dropUpLocation;
    jsonData['phone']=phone;
    return jsonData;

  }

}