import 'package:bidverse_frontend/providers/locale_provider.dart';
import 'package:bidverse_frontend/providers/user_provider.dart';
import 'package:bidverse_frontend/screens/login_screen.dart';
import 'package:bidverse_frontend/screens/product_upload_screen.dart';
import 'package:bidverse_frontend/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Stripe.publishableKey = "pk_test_51NJIz1KaOSJFrOtG7JlYGHj5JKYRAmjkBraBehCYLS7optjPLGCGgNBs1LjyJ8m6TxuOfWQhydu951msJlMDTDzR00tBlO5LJp";
  await dotenv.load(fileName: "assets/.env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      builder: (context, child) {
        LocaleProvider localeProvider = Provider.of<LocaleProvider>(context);

        return MaterialApp(
          title: 'Q Pay',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          locale: localeProvider.getLocale(),
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SplashScreen(),
          ),
        );
      },
    );
  }
}
