import 'dart:async';

import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/models/UserModel.dart';
import 'package:bidverse_frontend/providers/user_provider.dart';
import 'package:bidverse_frontend/screens/nav_bar_screen.dart';
import 'package:bidverse_frontend/screens/login_screen.dart';
import 'package:bidverse_frontend/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserProvider userProvider = UserProvider();
  UserModel? user;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      StorageService.getAuthUser().then((userFromStorage) {
        user = userFromStorage;
      }).whenComplete(() {
        if (user != null) {
          userProvider.setUser(user!);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBarScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      });
    });

    // Timer(const Duration(seconds: 3), () {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkBlueColor,
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Image.asset(logoWithoutBg),
          ),
        ),
      ),
    );
  }
}
