import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_tracing/controller/ble_controller.dart';
import 'package:contact_tracing/utils/colors.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapTracer extends StatefulWidget {
   MapTracer({super.key});

  @override
  State<MapTracer> createState() => _MapTracerState();
}

class _MapTracerState extends State<MapTracer> {
  late GoogleMapController mapController;

  Location location = Location();
 final controller=Get.put(BluetoothController());

  late LatLng currentLocation;
  bool locationGot=false;

  GoogleMapController? _controller;
  List<Marker> _markers = [];

  // Initialize Firebase and fetch marker locations
  void _fetchMarkers() async {
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('locations').get();

    setState(() {
      _markers = snapshot.docs.map((DocumentSnapshot doc) {
      var lat=doc.get('lat');
      var long=doc.get('long');
        return Marker(
          markerId: MarkerId(doc.id),
          position:LatLng(lat,long),
          // You can customize the marker icon here
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'SOPs violated here'),
        );
      }).toList();
    });
  }
  @override
  void initState() {
    super.initState();
    getLocation();
    _fetchMarkers();
    // controller.fetchMarkers();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Violation Map'),
      ),
      body: _markers.isEmpty
              ? const Center(child: CircularProgressIndicator())
              :locationGot? GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: Set<Marker>.of(_markers),
            // markers: {
            //
            //   Marker(
            //     markerId: const MarkerId('currentLocation'),
            //     position: currentLocation!,
            //     infoWindow: const InfoWindow(title: 'Current Location'),
            //   ),
            //   // Marker(
            //   //   markerId: const MarkerId('violated location'),
            //   //   position: controller.currentLocation,
            //   //   infoWindow: const InfoWindow(title: 'violated Location'),
            //   // )
            //
            // },
          ): const Center(child: CircularProgressIndicator()),

    );
  }

   getLocation() async{
    var data=await location.getLocation();
    setState(() {
      currentLocation=LatLng(data.latitude!, data.longitude!);
      locationGot=true;
    });
   }
}
