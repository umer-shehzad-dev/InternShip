import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_tracing/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  RxBool isNotVisible = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store=FirebaseFirestore.instance;
  TextEditingController uName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController location = TextEditingController();

  bool validateStructure(String value) {
    String pattern = r'[0-9\\/:*?"<>|@^%#!$\(\)\[\]{}]';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
  bool validateNumber(String value) {
    String pattern = r'[0-9]';
    RegExp regExp = RegExp(pattern);
    return !regExp.hasMatch(value);
  }
  bool validatePassword(String password) {
    String passwordPattern =
        r'^(?=.*[0-9])(?=.*[!@#\$%^&*])(?=.*[a-z])(?=.*[A-Z]).{8,}$';
    RegExp regExp = RegExp(passwordPattern);
    return !regExp.hasMatch(password);
  }

  bool validateEmail(String email) {
    String emailPattern =
        r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$';
    RegExp regExp = RegExp(emailPattern);
    return !regExp.hasMatch(email);
  }
  signUp() async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email.text, password: password.text).then((value) {
          if(_auth.currentUser!=null){
            Get.offAllNamed(MyRoutes.getHomePage());

          }
          else{
            Get.offAllNamed(MyRoutes.getSigninPage());
          }
    }).catchError((error) {
      if(error is FirebaseAuthException){
        Fluttertoast.showToast(msg: error.code.toString());
      }
    });

      saveUserData();

  }

  saveUserData() async{
     await _store.collection('user').doc(_auth.currentUser!.uid).set({
       'uid':_auth.currentUser!.uid,
       'username':uName.text,
       'email':email.text,
       'age':age.text,
       'gender':gender.text,
       'location':location.text,
       'hasCorona':false
     },
         SetOptions(merge: true)).catchError((error){
           if(error is FirebaseException){
             Fluttertoast.showToast(msg: error.code.toString());
           print(error.code.toString());
           }
     });
   }
}
