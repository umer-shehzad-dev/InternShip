import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController extends GetxController {



   LocationData? currentLocation;
   RxList markers=[].obs;

  get CurrentLocation => currentLocation;

   Location location = Location();

  Future scanDevices() async{
    var blePermission = await Permission.bluetoothScan.status;
    // if(blePermission.isDenied){
      // if(await Permission.bluetoothScan.request().isGranted){
          print('in bluetooth');
          FlutterBluePlus.startScan(timeout: const Duration(seconds: 20),continuousUpdates:true,);
          FlutterBluePlus.scanResults.listen((results){
            print('results$results');
            // scanResults=Stream<List<ScanResult>>.fromIterable(results as Iterable<List<ScanResult>>);
          },);
          // FlutterBluePlus.stopScan();
        // }
    // }

    // else{
    //   FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    //   FlutterBluePlus.stopScan();
    // }
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  int calculateDistance(int rssi, int txPower) {
    // Path Loss Exponent (n) for free space
    double n = 2.0;

    // Calculate the distance using the formula
    var distance = pow(10, (((-52) - rssi) / (10 * n))).toDouble();

    return distance.toInt();
  }

  setCurrentLocation()async{
  currentLocation= await location.getLocation();
  update();
  print('current location $currentLocation');
  }

   void fetchMarkers() async {
     final QuerySnapshot snapshot =
     await FirebaseFirestore.instance.collection('locations').get();

       markers!.value = snapshot.docs.map((DocumentSnapshot doc) {
        var data = doc.get('location');
         return Marker(
           markerId: MarkerId(doc.id),
           position: data,
           // You can customize the marker icon here
           icon: BitmapDescriptor.defaultMarker,
           infoWindow: const InfoWindow(title: 'SOPs Violated here'),
         );
       }).toList();
   }

   updateLocations()async{
     print('current location in update$currentLocation');
    await FirebaseFirestore.instance.collection('locations').add({
      'lat':currentLocation!.latitude,
      'long':currentLocation!.longitude
    });
   }
}
