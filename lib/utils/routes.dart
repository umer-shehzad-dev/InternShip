import 'package:contact_tracing/bindings/homeBinding.dart';
import 'package:contact_tracing/controller/homeController.dart';
import 'package:contact_tracing/views/home.dart';
import 'package:contact_tracing/views/signIn.dart';
import 'package:contact_tracing/views/signup.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class MyRoutes{
  static String home='/home';
  static String signInView='/signIn';
  static String signUpView='/signUp';

  static String getHomePage()=>home;
  static String getSigninPage()=>signInView;
  static String getSignUpPage()=>signUpView;


  static List<GetPage> appRoutes()=>[
    GetPage(name: getHomePage(), page:()=> const Home(),binding: AppBindings()),
    GetPage(name: getSigninPage(), page:()=> const SignIn(),binding: AppBindings()),
    GetPage(name: getSignUpPage(), page:()=> const SignUp(),binding: AppBindings())
  ];


}