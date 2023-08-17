import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app4/ui/screens/auth/login_screen.dart';
import 'package:mobile_app4/ui/screens/auth/reset_password.dart';
import 'package:mobile_app4/ui/state_managers/otp_verification_controller.dart';
import 'package:mobile_app4/ui/widgets/screen_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  /* bool _otpVerificationInProgress = false;

  Future<void> verifyOTP() async {
    _otpVerificationInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.otpVerify(widget.email, _otpTEController.text));
    _otpVerificationInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(
                  email: widget.email,
                  otp: _otpTEController.text,
                )));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Otp verification failed!')));
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 64,
                  ),
                  Text(
                    'OTP Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'A 6 digits pin will be sent to your email address',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  PinCodeTextField(
                    controller: _otpTEController,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.red,
                      activeColor: Colors.white,
                      selectedColor: Colors.green,
                      selectedFillColor: Colors.white,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    cursorColor: Colors.green,
                    enablePinAutofill: true,
                    onCompleted: (v) {},
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");

                      return true;
                    },
                    appContext: context,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GetBuilder<OtpVerificationController>(
                    builder: (otpVerificationController) {
                      return SizedBox(
                        width: double.infinity,
                        child: Visibility(
                          visible: otpVerificationController
                              .otpVerificationInProgress ==
                              false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              otpVerificationController
                                  .verifyOTP(widget.email, _otpTEController.text.trim())
                                  .then(
                                    (result) {
                                  if (result == true) {
                                    Get.to(
                                      ResetPasswordScreen(
                                        email: widget.email,
                                        otp: _otpTEController.text,
                                      ),
                                    );
                                  } else {
                                    Get.snackbar(
                                        'Failed!', 'OTP verification failed');
                                  }
                                },
                              );
                            },
                            child: const Text('Verify'),
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
                            fontWeight: FontWeight.w500, letterSpacing: 0.5),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                    (route) => false);
                          },
                          child: const Text('Sign in')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}