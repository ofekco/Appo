import 'package:Appo/models/authentication.dart';
import 'package:Appo/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../models/colors.dart';

class ChooseLoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   final deviceSize = MediaQuery.of(context).size;
   return Scaffold(
    body: Stack(
      children: <Widget>[
        SingleChildScrollView(
         child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(width: double.infinity, height: deviceSize.height/8,
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Center(child: Image.asset('assets/images/logo.JPG',)),
              )),
              Flexible(
                child: Container(
                margin: EdgeInsets.only(bottom: 50.0),
                padding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 65.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Palette.kToDark[500],
                  boxShadow: [
                    BoxShadow(
                     blurRadius: 8,
                     offset: Offset(0, 2))]),
                  child: Text(
                   'Welcome To Appo!',
                   style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.normal)),
                  ),
              ),
              Flexible(
               child:  ElevatedButton(
               onPressed: () {
                _showLoginScreen(context, AuthMode.BUSINESS);}, 
               child: Text("התחבר כעסק",
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryTextTheme.button.color,
                  )), 
               style: ElevatedButton.styleFrom(
                primary: Palette.kToDark[500],
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(30),
               )),
               //padding:
                 //EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
               //color: Palette.kToDark[500],
               //textColor: Theme.of(context).primaryTextTheme.button.color,
               ),
              ),
              Flexible(
                child: SizedBox(height: 10),
              ),
              Flexible(
               child:  ElevatedButton(
               onPressed: () {
                _showLoginScreen(context, AuthMode.CUSTOMER);},
               child: Text("התחבר כלקוח", 
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryTextTheme.button.color
                )),
                style: ElevatedButton.styleFrom(
                primary: Palette.kToDark[500],
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(30),
               )),
              //  shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(30)),
              //  padding:
              //   EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
              //  color: Palette.kToDark[500],
              //  textColor: Theme.of(context).primaryTextTheme.button.color,
              ),
            )
          ]
        )
      )
    )]
  ));
  }

  void _showLoginScreen(BuildContext context, AuthMode authMode) {
    Provider.of<Authentication>(context, listen: false).setAuthMode(authMode);
    Navigator.of(context).pushNamed(AuthScreen.routeName);
  }

  
}