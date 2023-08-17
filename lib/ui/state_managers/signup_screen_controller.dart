import 'package:get/get.dart';
import 'package:mobile_app4/data/services/network_caller.dart';
import 'package:mobile_app4/data/utils/urls.dart';

class SignUpScreenController extends GetxController {
  bool _signUpInProgress = false;
  bool get signUpProgress => _signUpInProgress;
  Future<bool> userSignup(String email,String firstName, String lastName, String mobileNumber, String password) async {
    _signUpInProgress = true;
   update();
    final response = await NetworkCaller().postRequest(Urls.registration, <String, dynamic>{
      "email":email,
      "firstName":firstName,
      "lastName":lastName,
      "mobile":mobileNumber,
      "password":password,
      "photo":""

    }
    );
    _signUpInProgress = false;
    update();
    if(response.isSuccess) {
      return true;
    }
    else {
      return false;
    }
  }
}