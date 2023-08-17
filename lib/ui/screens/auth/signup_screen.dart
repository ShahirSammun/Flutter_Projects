import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app4/ui/state_managers/signup_screen_controller.dart';
import 'package:mobile_app4/ui/widgets/screen_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileNumberTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  /*bool _signupInProgress = false;

  Future<void> userSignup() async {
    _signupInProgress = true;
    if(mounted){
      setState(() {

      });
    }
    final response = await NetworkCaller().postRequest(Urls.registration, <String, dynamic>{
      "email":_emailTEController.text.trim(),
      "firstName":_firstNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_mobileNumberTEController.text.trim(),
      "password":_passwordTEController.text,
      "photo":""

    }
    );
    _signupInProgress = false;
    if(mounted){
      setState(() {

      });
    }
    if(response.isSuccess) {
      _emailTEController.clear();
      _firstNameTEController.clear();
      _lastNameTEController.clear();
      _mobileNumberTEController.clear();
      _passwordTEController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Success')));
      }
    }
    else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Failed')));
      }
    }
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child:Form(
                key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64,),
                  Text(
                    'Join with us',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailTEController ,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return 'Enter your Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    controller: _firstNameTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    controller: _lastNameTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                   TextFormField(
                     controller: _mobileNumberTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Mobile Number',
                    ),
                     validator: (String? value){
                       if((value?.isEmpty ?? true) || value!.length<11){
                         return 'Enter your valid Mobile Number';
                       }
                       return null;
                     },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (String? value){
                      if((value?.isEmpty ?? true) || value!.length<=5){
                        return 'Enter a valid password of more than 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GetBuilder<SignUpScreenController>(
                    builder: (signUpController) {
                      return SizedBox(
                        width: double.infinity,
                        child: Visibility(
                          visible: signUpController.signUpProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_formkey.currentState!.validate()) {
                                return;
                              }
                              signUpController.userSignup(
                                  _emailTEController.text.trim(),
                                  _firstNameTEController.text.trim(),
                                  _lastNameTEController.text.trim(),
                                  _mobileNumberTEController.text.trim(),
                                  _passwordTEController.text)
                                  .then(
                                    (result) {
                                  if (result == true) {
                                    Get.snackbar('Successful','SignUp successfully done');
                                    _emailTEController.clear();
                                    _firstNameTEController.clear();
                                    _lastNameTEController.clear();
                                    _mobileNumberTEController.clear();
                                    _passwordTEController.clear();
                                  } else {
                                    Get.snackbar('Failed','Sign in failed');
                                  }
                                },
                              );
                            },
                            child:
                            const Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Have an account?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,letterSpacing: 0.5),
                      ),
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: const Text('Sign in')),
                    ],
                  )
                ],
              ),
            ),
            ),
          ),
        ));
  }
}