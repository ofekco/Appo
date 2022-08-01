import 'package:Appo/models/authentication.dart';
import 'package:Appo/models/businesses.dart';
import 'package:Appo/screens/auth_screen.dart';
import 'package:Appo/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/tabs_screen.dart';
import './models/colors.dart';
import './models/businesses.dart';
import 'package:intl/date_symbol_data_local.dart';
import './screens/splash.dart';


void main() {
  initializeDateFormatting()
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
         create: (_) => Businesses()),
        ChangeNotifierProvider.value(
          value: Authentication())
      ],
      child: Consumer<Authentication>(
        builder: (ctx, auth, _) => MaterialApp(
        title: 'Appo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Palette.kToDark[800],
          primarySwatch: Palette.kToDark,
          brightness: Brightness.light,
          accentColor: Palette.kToDark[500],
          canvasColor: Colors.white,
          cardColor: Palette.kToDark[0],
          focusColor: const Color.fromRGBO(237, 125, 166, 1),
        ),
        home: auth.isAuth ? HomeScreen() : AuthScreen(),
        // routes: {
        //   BusinessDetailsScreen.routeName: (context) => BusinessDetailsScreen(),
        // },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (c) => TabsScreen(),);
        },
      ),
    ));  
  }
}
