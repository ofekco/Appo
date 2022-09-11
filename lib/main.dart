import 'package:Appo/Business_side/screens/business_home_page.dart';
import 'package:Appo/screens/profile_screen.dart';
import 'package:Appo/screens/registration_screen.dart';
import 'Business_side/screens/registration_screen1.dart';
import 'package:Appo/models/authentication.dart';
import 'package:Appo/models/businesses.dart';
import 'package:Appo/screens/chooce_login.dart';
import 'package:Appo/screens/login_screen.dart';
import 'package:Appo/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Business_side/screens/registration_screen2.dart';
import 'models/types.dart';
import 'screens/tabs_screen.dart';
import './models/colors.dart';
import './models/businesses.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'Business_side/screens/registration_explanation_screen.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Businesses>(create: (_) => Businesses()),
          ChangeNotifierProvider<Types>(create: (_) => Types()),
          ChangeNotifierProvider<Authentication>(
              create: (_) => Authentication()),
        ],
        child: Consumer<Authentication>(
          builder: (ctx, auth, _) => 
          MaterialApp(
              title: 'Appo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Palette.kToDark[800],
                primarySwatch: Palette.kToDark,
                brightness: Brightness.light,
                accentColor: Palette.kToDark[500],
                canvasColor: Colors.white,
                cardColor: Palette.kToDark[0],
                focusColor: Palette.kToDark[50],
              ),
              home: auth.isAuth
                ? auth.authMode == AuthMode.CUSTOMER
                    ? TabsScreen()
                    : BusinessHomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                        ConnectionState.waiting
                          ? AnimatedSplashScreen(
                                  duration: 30000,
                                  splash: Image.asset('assets/images/logo.JPG'),
                                  nextScreen: ChooseLoginScreen(),
                                  backgroundColor: Colors.white,
                                )
                          : ChooseLoginScreen(),
                  ),
              routes: {
                '/home': (ctx) => HomeScreen(),
                '/auth': (ctx) => AuthScreen(),
                '/register': (ctx) => RegistrationScreen(),
                '/first': (ctx) => TabsScreen(),
                '/business_home': (ctx) => BusinessHomeScreen(),
                '/register_business1': (ctx) => BusinessRegistrationScreen1(),
                '/register_business2': (ctx) => BusinessRegistrationScreen2(),
                '/explain': (ctx) => RegisterationExplenationScreen(),
                '/customer_profile': (ctx) =>
                    ProfileScreen(Provider.of<Authentication>(ctx).currentUser),
              }),
        ));
  }
}
