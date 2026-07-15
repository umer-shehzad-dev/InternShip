import 'package:contact_tracing/controller/signInController.dart';
import 'package:contact_tracing/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../utils/colors.dart';
import '../utils/textStyles.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _signInformKey=GlobalKey<FormState>();
  final controller=Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return  SafeArea(
        child:Scaffold(
          appBar:  AppBar(
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
                  'Sign In',
                  style: CustomTextStyles.heading,
                ),
                SizedBox(height: size.height*0.04,),
                Form(
                    key: _signInformKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.1, right: size.width * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          TextFormField(
                            validator: (value){
                              if(controller.validateEmail(value!)) {
                                return 'Enter Valid Email i.e. someone@example.com';
                              }
                              else if(value.isEmpty){
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
                          Obx(
                                ()=> TextFormField(
                                  controller: controller.pass,
                                  validator: (value){
                                    if(controller.validatePassword(value!)) {
                                      return 'Enter Valid Password';
                                    }
                                    else if(value.isEmpty){
                                      return 'Enter Password';
                                    }
                                  },
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
                                    suffixIcon: IconButton(
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
                            onTap: (){
                              if(_signInformKey.currentState!.validate()){
                                controller.signInWithEmail(context);
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
                                child: Text('Sign In',style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black54
                                ),),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height*0.02,),
                          TextButton(onPressed: (){
                           Get.offAll(const SignUp());
                          },
                              child: const Text('Don\'t have an account? Sign Up',
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
        )
    );
  }
}
