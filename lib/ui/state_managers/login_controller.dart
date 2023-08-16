import 'package:get/get.dart';
import 'package:mobile_app4/data/models/auth_utility.dart';
import 'package:mobile_app4/data/models/login_model.dart';
import 'package:mobile_app4/data/models/network_response.dart';
import 'package:mobile_app4/data/services/network_caller.dart';
import 'package:mobile_app4/data/utils/urls.dart';

class LoginController extends GetxController{
  bool _loginInProgress = false;
  bool get loginInProgress => _loginInProgress;
  Future<bool> login(String email, String password) async {
    _loginInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password
    };
    final NetworkResponse response = await NetworkCaller()
        .postRequest(Urls.login, requestBody, isLogin: true);
    _loginInProgress = false;
    update();
    if (response.isSuccess && response.statuscode==200) {
      LoginModel model = LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(LoginModel.fromJson(response.body!));
      return true;
    } else {
     return false;
    }
  }
}