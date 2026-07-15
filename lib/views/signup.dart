import 'package:contact_tracing/controller/signUpController.dart';
import 'package:contact_tracing/utils/colors.dart';
import 'package:contact_tracing/utils/routes.dart';
import 'package:contact_tracing/utils/textStyles.dart';
import 'package:contact_tracing/views/signIn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final controller=Get.put(SignUpController());

  final _signUpformKey=GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title:Text('Contact Tracing-Covid Control',style: CustomTextStyles.appBarTitleStyle14,),
        backgroundColor: MyColors.PrimaryColor,
        leading: null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height*0.15,),
            Text(
              'Register',
              style: CustomTextStyles.heading,
            ),
            SizedBox(height: size.height*0.04,),
            Form(
              key: _signUpformKey,
                child: Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.1, right: size.width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormField(
                    validator: (name){
                      if (controller.validateStructure(name.toString())){
                        return 'Enter Proper Name';
                      }
                      else if(name!.isEmpty){
                        return 'Enter Name';
                      }
                    },
                    controller: controller.uName,
                    cursorColor: Colors.amberAccent,
                    style: CustomTextStyles.inputStyle,
                    decoration: InputDecoration(
                      label:const Text('Name'),
                        labelStyle: CustomTextStyles.labelStyle,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.SecondaryColor)
                        ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.SecondaryColor)
                      ),

                    ),
                  ),
                  SizedBox(height: size.height*0.02,),
                  TextFormField(
                    validator: (email){
                      if(controller.validateEmail(email.toString())){
                        return 'Enter Proper Email i.e. someone@example.com';
                      }
                      else if(email!.isEmpty){
                        return 'Enter Email';
                      }
                    },
                    controller: controller.email,
                    cursorColor: Colors.amberAccent,
                    style: CustomTextStyles.inputStyle,
                    decoration: InputDecoration(
                      label:const Text('Email'),
                      labelStyle: CustomTextStyles.labelStyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.SecondaryColor)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.SecondaryColor)
                      ),

                    ),
                  ),
                  SizedBox(height: size.height*0.02,),
                  TextFormField(
                    validator: (age){
                      if(controller.validateNumber(age.toString())){
                        return 'Enter proper Age';
                      }
                      else if(age!.isEmpty){
                        return 'Enter Age';
                      }
                    },
                    controller: controller.age,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.amberAccent,
                    style: CustomTextStyles.inputStyle,
                    decoration: InputDecoration(
                      label:const Text('Age'),
                      labelStyle: CustomTextStyles.labelStyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.SecondaryColor)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.SecondaryColor)
                      ),

                    ),
                  ),
                  SizedBox(height: size.height*0.02,),
                  TextFormField(
                    validator: (gender){
                      if(controller.validateStructure(gender.toString())){
                        return 'Enter Proper Gender Name';
                      }
                      else if(gender!.isEmpty){
                        return 'Enter Gender';
                      }
                    },
                    controller: controller.gender,
                    cursorColor: Colors.amberAccent,
                    style: CustomTextStyles.inputStyle,
                    decoration: InputDecoration(
                      label:const Text('Gender'),
                      labelStyle: CustomTextStyles.labelStyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.SecondaryColor)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.SecondaryColor)
                      ),

                    ),
                  ),
                  SizedBox(height: size.height*0.02,),
                  TextFormField(
                    validator: (location){
                      if(controller.validateStructure(location.toString())){
                        return 'Enter Proper Location Name';
                      }
                      else if(location!.isEmpty){
                        return 'Enter Location';
                      }
                    },
                    controller: controller.location,
                    cursorColor: Colors.amberAccent,
                    style: CustomTextStyles.inputStyle,
                    decoration: InputDecoration(
                      label:const Text('Location'),
                      labelStyle: CustomTextStyles.labelStyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.SecondaryColor)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.SecondaryColor)
                      ),

                    ),
                  ),
                  SizedBox(height: size.height*0.02,),
                  Obx(
                    ()=> TextFormField(
                      validator: (pass){
                        if(controller.validatePassword(pass.toString())){
                          return 'Enter Valid Password';
                        }
                        else if(pass!.isEmpty){
                          return 'Enter Password';
                        }
                      },
                      controller: controller.password,
                      obscureText:controller.isNotVisible.value,
                      cursorColor: Colors.amberAccent,
                      style: CustomTextStyles.inputStyle,
                      decoration: InputDecoration(
                        prefixIcon:  Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          showDuration: const Duration(seconds: 4),
                          margin: const EdgeInsets.only(left: 40,right: 40),
                          message: 'Password must contain one special character, one capital letter, one small letter, And one number. It should have length more than or equal to 8',
                          child: Icon(Icons.info_outline_rounded,
                            color: MyColors.SecondaryColor,),
                        ),
                        suffixIcon:
                            IconButton(
                              onPressed: () {
                                controller.isNotVisible.value=!controller.isNotVisible.value;
                              },
                              icon:Icon(
                                controller.isNotVisible.isTrue?
                                Icons.visibility:Icons.visibility_off,
                                color: MyColors.PrimaryColor,),),
                        label:const Text('Password'),
                        labelStyle: CustomTextStyles.labelStyle,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.SecondaryColor)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.SecondaryColor)
                        ),

                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.04,),
                  InkWell(
                    onTap: () {
                      if(_signUpformKey.currentState!.validate()) {
                        controller.signUp();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        color: MyColors.PrimaryColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Center(
                        child: Text('Sign Up',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black54
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.02,),
                  TextButton(onPressed: (){
                   Get.offAllNamed(MyRoutes.getSigninPage());
                  },
                      child: const Text('Already have an account? Sign In',
                        style:TextStyle(
                    color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w800
                  ),))
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }
}


