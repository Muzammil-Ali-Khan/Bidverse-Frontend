import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/widgets/custom_button.dart';
import 'package:bidverse_frontend/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlueColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.login,
            style: const TextStyle(fontSize: 36.0, color: white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Text(
              AppLocalizations.of(context)!.email,
              style: const TextStyle(fontSize: 16.0, color: white),
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
              style: const TextStyle(fontSize: 16.0, color: white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: CustomTextField(
              hintText: '****',
              controller: emailController,
              icon: Icons.lock_outline,
              obscureText: true,
            ),
          ),
          const SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomButton(title: AppLocalizations.of(context)!.login, onPressed: () {}),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.dontHaveAnAccount,
                  style: const TextStyle(color: white, fontSize: 12.0),
                ),
                const SizedBox(width: 5.0),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.signUp,
                    style: const TextStyle(color: white, fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
