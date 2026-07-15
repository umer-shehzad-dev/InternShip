import 'package:contact_tracing/controller/homeController.dart';
import 'package:contact_tracing/utils/textStyles.dart';
import 'package:contact_tracing/views/profile_info_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final homeController=Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.PrimaryColor,
        title: Center(child: Text('My Profile',style: CustomTextStyles.appBarTitleStyle14,),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ProfilePlaceHolder(text:homeController.username.toString() ,title: 'Username',),
          const SizedBox(height: 10,),
          ProfilePlaceHolder(text:homeController.gender.toString(),title: 'Gender' ),
            const SizedBox(height: 10,),
          ProfilePlaceHolder(text:homeController.age.toString() ,title: 'Age'),
            const SizedBox(height: 10,),
          ProfilePlaceHolder(text:homeController.location.toString(),title: 'Location' ),
          ],
        ),
      ),
    );
  }
}
