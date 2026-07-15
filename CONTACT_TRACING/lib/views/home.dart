import 'package:contact_tracing/controller/ble_controller.dart';
import 'package:contact_tracing/controller/homeController.dart';
import 'package:contact_tracing/controller/selfAssesmentController.dart';
import 'package:contact_tracing/controller/upload_controller.dart';
import 'package:contact_tracing/utils/colors.dart';
import 'package:contact_tracing/utils/textStyles.dart';
import 'package:contact_tracing/views/contact_tracing.dart';
import 'package:contact_tracing/views/profile.dart';
import 'package:contact_tracing/views/selfAssessmentPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'map.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller=Get.put(HomeController());
  final uploadController=Get.put(UploadController());
  final assessmentController=Get.put(SelfAssessmentController());
  final bleController=Get.put(BluetoothController());

  @override
  void initState() {
    super.initState();
    controller.setUserDetail();
    setCoronaStatus();
  }
  setCoronaStatus(){
    print('corona status'+controller.hasCorona.toString());
        assessmentController.hasCorona.value=controller.hasCorona.value;
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.sizeOf(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Center(child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text('Dashboard',style: CustomTextStyles.heading,),
            ),
          const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Container(
                height: size.height*0.13,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child:  Obx(
                  ()=>Column(
                    children: [
                      const SizedBox(height: 10,),
                      const Text('Status',style: TextStyle(
                        color: Colors.black
                      ),),
                      const SizedBox(height: 30,),
                      Text('${controller.checkHasCorona()??''}',
                        style:  TextStyle(
                        color:controller.checkHasCorona()=='Minimum Risk'? Colors.green:controller.checkHasCorona()=='Medium Risk'?Colors.yellow:Colors.red,
                        fontSize: 15
                      ),)
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
        backgroundColor: MyColors.PrimaryColor,
        toolbarHeight:size.height*0.3,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Column(
              children: [
                IconButton(
                    tooltip:'Logout',
                    onPressed: (){
                  controller.logOut(context);
                }, icon: const Icon(Icons.logout,color: Colors.black,size: 30,)),
                Text('Logout',style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: MyColors.SecondaryColor
                ),)
              ],
            ),
          )
        ],
      ),
      body: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20),
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2
          ),
          itemCount: 5,
          itemBuilder:(context,index){
            return InkWell(
              onTap: ()async{
                var tappedIndex=index;
                switch(tappedIndex){
                  case 0:
                    showDialog(context: context, builder:(context){
                      return const Center(child: CircularProgressIndicator(color: Colors.amber,));
                    });
                    await uploadController.openFileExplorer(randomAlphaNumeric(8),controller.username.toString(),controller.uId, context);
                    break;
                  case 1:
                    PersistentNavBarNavigator.pushNewScreen(context, screen:  SelfAssessment(onPressed: (){
                      setState(() {
                      });},
                    ));
                    break;
                  case 2:
                      PersistentNavBarNavigator.pushNewScreen(context, screen:  MapTracer());
                    break;
                  case 3:

                    PersistentNavBarNavigator.pushNewScreen(context, screen: const ContactTracing());
                    break;
                  case 4:
                    PersistentNavBarNavigator.pushNewScreen(context, screen: const ProfileView());
                    break;
                }
              },
              child: Column(
                children: [
                  Image(image: AssetImage(controller.iconPaths[index]),height:80,width: 80),
                  const SizedBox(height: 10,),
                  Text(controller.name[index],style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            );
          }),
    ));
  }
}
