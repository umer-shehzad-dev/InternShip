import 'dart:io';

import 'package:contact_tracing/utils/routes.dart';
import 'package:contact_tracing/views/home.dart';
import 'package:contact_tracing/views/signIn.dart';
import 'package:contact_tracing/views/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Request permission for Bluetooth
  await Permission.bluetooth.request();
  await Permission.bluetoothScan.request();
  await Permission.bluetoothAdvertise.request();

  // Request permission for location
  await Permission.location.request();
  if(await Permission.location.status.isPermanentlyDenied){
    openAppSettings();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // enableBluetoothAndLocation() async {
  //   // Request location permission
  //   var status = await Permission.location.request();
  //   if (status.isGranted) {
  //     // Location permission granted, check and enable Bluetooth
  //     bool isAvailable = await FlutterBluePlus.isOn;
  //     if (!isAvailable) {
  //       await FlutterBluePlus.requestPermissions();
  //       await FlutterBluePlus.startScan();
  //     }
  //   } else {
  //     // Permission denied
  //     // You can handle this according to your app's requirements
  //   }
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final FirebaseAuth _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:_auth.currentUser!=null?MyRoutes.getHomePage():MyRoutes.getSigninPage(),
      getPages: MyRoutes.appRoutes(),
    );
  }
}
