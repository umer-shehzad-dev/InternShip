import 'package:contact_tracing/controller/ble_controller.dart';
import 'package:contact_tracing/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ContactTracing extends StatefulWidget {
  const ContactTracing({super.key});

  @override
  State<ContactTracing> createState() => _ContactTracingState();
}


class _ContactTracingState extends State<ContactTracing> {

  final controller=Get.put(BluetoothController());
  bool isViolated=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(onPressed:(){
              setState(() {
                controller.scanDevices();
              });
              // if(controller.calculateDistance(data.rssi, data.advertisementData.txPowerLevel??12)<6){
              //   showSnackBar(context);
              // }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.PrimaryColor
            ), child:  Text('Scan People',style: TextStyle(
              color:  MyColors.SecondaryColor
            ),),
            ),
          ),
        ],
      ),
      body: GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (BluetoothController controller) {
          return StreamBuilder<List<ScanResult>>(stream: controller.scanResults, builder: (context,snap){
            print('in stream builder');
            if(snap.hasData){
             return ListView.separated(itemBuilder: (context,index){
                final data=snap.data![index];
                // print('device name${data.device.advName}');
                // print('device rssi${data.rssi}');
                // print('device txPower ${data.advertisementData.txPowerLevel}');
                // print('device distance ${controller.calculateDistance(data.rssi, data.advertisementData.txPowerLevel??12)}');
                if(controller.calculateDistance(data.rssi, data.advertisementData.txPowerLevel??12)<6&&!isViolated){
                 Fluttertoast.showToast(msg: 'You are violating SOPs!',backgroundColor: Colors.red,toastLength: Toast.LENGTH_LONG);
                controller.setCurrentLocation();
                Future.delayed(const Duration(seconds: 5));
                controller.updateLocations();
                   isViolated=true;
                }
                return Container(
                  decoration:  BoxDecoration(
                    color: controller.calculateDistance(data.rssi, data.advertisementData.txPowerLevel ?? 12)<6?Colors.red:Colors.green
                  ),
                  child: ListTile(
                    title: Text(data.device.advName,style:  const TextStyle(
                      color: Colors.black
                    ),),
                    trailing: Text("Distance\n ${controller.calculateDistance(data.rssi, data.advertisementData.txPowerLevel ?? 12)==0?1:controller.calculateDistance(data.rssi, data.advertisementData.txPowerLevel ?? 12)} Meter"),
                    subtitle: Text(data.device.remoteId.str),
                  ),
                );
              }, separatorBuilder: (context,index){
                return const SizedBox(height: 10,);
              }, itemCount:snap.data!.length );
            }
            else {
              return  Center(
                child: Text("No Device Found Nearby",style: TextStyle(
                  color: MyColors.SecondaryColor
                ),),
              );
            }
          });
        },
      ),
    );
  }


}
