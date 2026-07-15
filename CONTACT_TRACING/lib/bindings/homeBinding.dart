import 'package:contact_tracing/controller/homeController.dart';
import 'package:contact_tracing/controller/signInController.dart';
import 'package:contact_tracing/controller/signUpController.dart';
import 'package:contact_tracing/views/signup.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class AppBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<HomeController>(
        ()=>HomeController()
    );

    Get.lazyPut<SignInController>(
        ()=>SignInController()
    );
    Get.lazyPut<SignUpController>(
        ()=>SignUpController()
    );

  }

}