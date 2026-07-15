import 'package:contact_tracing/controller/homeController.dart';
import 'package:contact_tracing/controller/selfAssesmentController.dart';
import 'package:contact_tracing/utils/colors.dart';
import 'package:contact_tracing/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelfAssessment extends StatefulWidget {
  Function() onPressed;
   SelfAssessment({super.key,required this.onPressed});

  @override
  State<SelfAssessment> createState() => _SelfAssessmentState();
}

class _SelfAssessmentState extends State<SelfAssessment> {
  final controller = Get.put(SelfAssessmentController());
  final homeController = Get.put(HomeController());
  int yesCounter=0;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Self Assessment Form',
          style: CustomTextStyles.appBarTitleStyle14,
        )),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: MyColors.SecondaryColor,
          ),
        ),
        backgroundColor: MyColors.PrimaryColor,
      ),
      body: Obx(
        ()=>Stepper(
          physics: const AlwaysScrollableScrollPhysics(),
          type: StepperType.vertical,
          currentStep: controller.currentStep.value,
          controlsBuilder: (context, _) {
            if(controller.currentStep<9){
              return SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: MyColors.PrimaryColor),
                          color: Colors.transparent),
                      child: Center(
                        child: TextButton(
                            onPressed: () {
                              if(controller.currentStep<9) {
                                controller.currentStep.value++;
                                setState(() {
                                  yesCounter+=0;
                                });
                              }
                            },
                            child: Text(
                              'No',
                              style: TextStyle(color: MyColors.PrimaryColor),
                            )),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: MyColors.PrimaryColor),
                      child: Center(
                        child: TextButton(
                            onPressed: () {
                              if(controller.currentStep<9) {
                                controller.currentStep.value++;
                                setState(() {
                                  yesCounter+=2;
                                });
                              }
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: MyColors.SecondaryColor),
                            )),
                      ),
                    ) ,
                    const SizedBox(width: 20,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: MyColors.PrimaryColor),
                      child: Center(
                        child: TextButton(
                            onPressed: () {
                              if(controller.currentStep<9) {
                                controller.currentStep.value++;
                                setState(() {
                                  yesCounter+=1;
                                });
                              }
                            },
                            child: Text(
                              'Not Sure',
                              style: TextStyle(color: MyColors.SecondaryColor),
                            )),
                      ),
                    )
                  ],
                ),
              );

            }
            else{
              return const SizedBox();
            }
          },
          steps:  [
            const Step(
                title: Text(
                    '1.Have you experienced any of the following symptoms in the past 14 days Fever Cough Shortness of breath or difficulty breathing?'),
                content: SizedBox()),
            const Step(
                title: Text('2.Have you had close contact with someone who tested positive for COVID-19 in the last 14 days?'),
                content: SizedBox()),
            const Step(
                title: Text(
                    '''3. Have you traveled internationally in the last 14 days or been in an area with a high COVID-19 transmission rate?
        
                    '''),
                content: SizedBox()), const Step(
                title: Text(
                    '''4. Are you currently awaiting the results of a COVID-19 test?'''),
                content: SizedBox()), const Step(
                title: Text(
                    '''5. Have you attended any large gatherings or events in the last 14 days?
        
                    '''),
                content: SizedBox()), const Step(
                title: Text(
                    '''6. Do you work in a high-risk environment (e.g., healthcare, crowded settings)?
        
                    '''),
                content: SizedBox()), const Step(
                title: Text(
                    '''7. Have you experienced fatigue, muscle or body aches, headache, or other flu-like symptoms?
        
                    '''),
                content: SizedBox()), const Step(
                title: Text(
                    '''8. Are you part of a high-risk group (e.g., elderly, immunocompromised)?
        
                    '''),
                content: SizedBox()), const Step(
                title: Text(
                    '''9. Have you been following recommended safety measures, such as wearing masks and practicing social distancing?
                    '''),
                content: SizedBox()),
            Step(
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: MyColors.PrimaryColor
                  ),
                  child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context,false);
                                  controller.currentStep.value=0;
                                    controller.hasCorona.value=true;
                                    homeController.updateCoronaStatus(homeController.uId.toString(),yesCounter );
                                  widget.onPressed();

                              }, child: Text('Submit Form',style: TextStyle(
                    color: MyColors.SecondaryColor
                  ),),),
                ), content: const SizedBox())
          ],
        ),
      ),
    ));
  }
}
