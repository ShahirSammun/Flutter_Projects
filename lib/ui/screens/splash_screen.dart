
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app4/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app4/ui/utils/assets_utils.dart';
import 'package:mobile_app4/ui/widgets/screen_background.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    navigatorToLogin();
  }

  void navigatorToLogin(){
    Future.delayed(const Duration(seconds: 3)).then((_){
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context)=>const LoginScreen()),
            (route) => false,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SvgPicture.asset(
          AssetsUtils.logoSvg,
          width:90,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}

