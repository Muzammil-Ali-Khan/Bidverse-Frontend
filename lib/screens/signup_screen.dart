import 'dart:convert';

import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/screens/login_screen.dart';
import 'package:bidverse_frontend/screens/nav_bar_screen.dart';
import 'package:bidverse_frontend/services/http_service.dart';
import 'package:bidverse_frontend/widgets/custom_button.dart';
import 'package:bidverse_frontend/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/urls.dart';
import '../models/UserModel.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';
import '../widgets/custom_snackbar.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Providers
  UserProvider userProvider = UserProvider();

  Future<bool> _handleSignup(BuildContext context) async {
    var data = {
      "email": emailController.text,
      "password": passwordController.text,
      'name': nameController.text,
      'number': numberController.text,
      'image': 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
    };

    var response = await HttpService.post(URLS.signup, data: data);

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
      backgroundColor: white,
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
                    const SizedBox(height: 10.0),
                    Text(
                      AppLocalizations.of(context)!.signUp,
                      style: const TextStyle(fontSize: 36.0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Text(
                        AppLocalizations.of(context)!.userName,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: CustomTextField(
                        hintText: 'User',
                        controller: nameController,
                        icon: Icons.person_outline_outlined,
                      ),
                    ),
                    const SizedBox(height: 10.0),
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
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Text(
                        AppLocalizations.of(context)!.phoneNumber,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: CustomTextField(
                        hintText: '0325685335',
                        controller: numberController,
                        icon: Icons.phone_outlined,
                      ),
                    ),
                    const SizedBox(height: 10.0),
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
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CustomButton(
                          title: AppLocalizations.of(context)!.signUp,
                          onPressed: () async {
                            if (emailController.text == '' ||
                                passwordController.text == '' ||
                                nameController.text == '' ||
                                numberController.text == '') {
                              ScaffoldMessenger.of(context).showSnackBar(customSnackBar('Please fill out all the fields first'));
                            } else {
                              bool result = await _handleSignup(context);
                              if (result) {
                                print("Successful signup");
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBarScreen()), (r) => false);
                              }
                              // else {
                              //   ScaffoldMessenger.of(context).showSnackBar(customSnackBar('Something went wrong'));
                              // }
                            }
                          }),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.alreadyHaveAnAccount,
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          const SizedBox(width: 5.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            child: Text(
                              AppLocalizations.of(context)!.login,
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
