import 'package:contact_tracing/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignInController extends GetxController
{
  RxBool isNotVisible=true.obs;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  TextEditingController email=TextEditingController();
  TextEditingController pass=TextEditingController();

  signInWithEmail(BuildContext context){
    _auth.signInWithEmailAndPassword(email: email.text,
        password: pass.text).then((value) {
          if(_auth.currentUser!=null) {
            Get.offNamed(MyRoutes.getHomePage());
          }
    }).catchError((error){
      if(error is FirebaseAuthException) {
        Fluttertoast.showToast(msg: error.code.toString());
      }
    });

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
}