import 'package:cloud_firestore/cloud_firestore.dart';

class TokenService{

   static FirebaseFirestore firestore=FirebaseFirestore.instance;


  Future<void> storePassengerToken(String deviceToken) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('passengerDeviceToken')
        .where('token', isEqualTo: deviceToken)
        .get();
    if (querySnapshot.docs.isEmpty) {
      await firestore.collection('passengerDeviceToken').add({
        'token': deviceToken,
      });
    }
  }


 static Future<List<String>> getAdminDeviceTokens() async {
    QuerySnapshot querySnapshot = await firestore.collection('adminDeviceTokens').get();
    List<String> deviceTokens = [];

    querySnapshot.docs.forEach((doc) {
      deviceTokens.add(doc['token']);
    });

    return deviceTokens;
  }




}