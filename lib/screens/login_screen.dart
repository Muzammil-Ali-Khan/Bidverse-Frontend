import 'dart:convert';

import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/constants/urls.dart';
import 'package:bidverse_frontend/providers/user_provider.dart';
import 'package:bidverse_frontend/screens/nav_bar_screen.dart';
import 'package:bidverse_frontend/screens/product_upload_screen.dart';
import 'package:bidverse_frontend/screens/signup_screen.dart';
import 'package:bidverse_frontend/services/http_service.dart';
import 'package:bidverse_frontend/widgets/custom_button.dart';
import 'package:bidverse_frontend/widgets/custom_snackbar.dart';
import 'package:bidverse_frontend/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/UserModel.dart';
import '../services/storage_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Providers
  UserProvider userProvider = UserProvider();

  Future<bool> _handleLogin(BuildContext context) async {
    var data = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    var response = await HttpService.post(URLS.login, data: data);

    if (response.success) {
      // Set token
      String token = response.data!["token"];
      StorageService.setAuthToken(token);

      // Set User in Provider and storage
      Map<String, dynamic> data = response.data!["user"];
      UserModel user = UserModel.fromJson(data);
      userProvider.setUser(user);
      StorageService.setAuthUser(user);

      return true;
    } else {
      var errorMessage = response.error;
      var jsonError = json.decode(errorMessage!);
      var realErrorMessage = jsonError['message'];
      print('real error is $realErrorMessage');

      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(realErrorMessage));

      debugPrint("Error: ${response.error}");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/loginBottom.png",
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.bottomLeft,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(fontSize: 36.0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Text(
                        AppLocalizations.of(context)!.email,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: CustomTextField(
                        hintText: 'email@gmail.com',
                        controller: emailController,
                        icon: Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Text(
                        AppLocalizations.of(context)!.password,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: CustomTextField(
                        hintText: '****',
                        controller: passwordController,
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CustomButton(
                        title: AppLocalizations.of(context)!.login,
                        onPressed: () async {
                          if (emailController.text == '' || passwordController.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(customSnackBar('Please fill out all the fields first'));
                          } else {
                            bool result = await _handleLogin(context);
                            if (result) {
                              print("Successful login");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NavBarScreen()));
                            }
                            // else {
                            //   ScaffoldMessenger.of(context).showSnackBar(customSnackBar('Something went wrong'));
                            // }
                          }
                        },
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dontHaveAnAccount,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          const SizedBox(width: 5.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signUp,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
