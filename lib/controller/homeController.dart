import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../utils/routes.dart';

class HomeController extends GetxController {
  List iconPaths = [
    'lib/assets/png_icons/reportIcon.png',
    'lib/assets/png_icons/assessmentIcon.png',
    'lib/assets/png_icons/location_icon.png',
    'lib/assets/png_icons/personsIcon.jpeg',
    'lib/assets/png_icons/personIcon.jpeg',
  ];
  List name = [
    'Upload report',
    'Take A Self Assessment',
    'Corona Locator',
    'Contact Tracing',
    'Profile'
  ];

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;

  String? username,uId,age,gender,location;
  RxBool hasCorona=false.obs;
  RxInt coronaPoints=0.obs;

  logOut(BuildContext context) {
    auth.signOut().then((value) {
      if (auth.currentUser == null) {
        Get.offAllNamed(MyRoutes.getSigninPage());
      }
    }).catchError((error) {
      if (error is FirebaseAuthException) {
        Fluttertoast.showToast(msg: error.code.toString());
      }
    });
  }

  setUserDetail()async{
    var userData=await store.collection('user').doc(auth.currentUser!.uid.toString()).get();
    username=userData.get('username');
    uId=userData.get('uid');
    age=userData.get('age');
    gender=userData.get('gender');
    location=userData.get('location');
    hasCorona.value=userData.get('hasCorona');
    coronaPoints.value=userData.get('corona_points');
  }

  updateCoronaStatus(String userId,int points)async{
    await store.collection('user').doc(userId).update({
    'corona_points':points
    });
  }


  checkHasCorona(){
    setUserDetail();
    print(coronaPoints.value);
    if(coronaPoints.value>=0&&coronaPoints.value<=2){
      return 'Minimum Risk';
    }
    else if(coronaPoints.value>=3&&coronaPoints.value<=5){
      return 'Medium Risk';
    }
    else if(coronaPoints.value>6){
      return 'High Risk';
    }
  }
}
