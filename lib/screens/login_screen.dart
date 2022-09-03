import 'package:Appo/models/colors.dart';
import 'package:Appo/models/http_exception.dart';
import 'package:Appo/screens/registration_screen.dart';
import 'package:Appo/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Appo/Business_side/screens/registration_screen1.dart' as businessSide;
import 'registration_screen.dart';
import '../models/authentication.dart';
import 'package:Appo/Business_side/screens/registration_explanation_screen.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';


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
                        offset: Offset(0, 2),
                       )
                      ],
                    ),
                    child: Text(
                      'התחברות',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: AuthCard(),
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();  

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      switch (Provider.of<Authentication>(context, listen: false).authMode) {
        case AuthMode.CUSTOMER: {
          await Provider.of<Authentication>(context, listen: false).login(_authData['email'], _authData['password']);
          Navigator.of(context).pushNamed(TabsScreen.routeName);
          break;
        }
        case AuthMode.BUSINESS: {
          Provider.of<Authentication>(context, listen: false).loginAsBusiness(_authData['email'], _authData['password']);

          break;
        }
      }
     
    }
    on HttpException catch (error) {
      var errorMessage = 'ההרשמה נכשלה';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'כתובת מייל כבר רשומה';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'כתובת מייל לא חוקית';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'הסיסמה חלשה מידי';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'כתובת מייל לא נמצאה';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'סיסמה לא נכונה';
      }
      _showErrorDialog(errorMessage);
    }
    catch(error) {
      var errorMessage = 'משהו השתבש, נסה שנית מאוחר יותר';
       _showErrorDialog(errorMessage);

    }
    
    setState(() {
      _isLoading = false;
    });
  }

   void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text('התרחשה שגיאה'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var authProvider = Provider.of<Authentication>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: 260,
        constraints:
            BoxConstraints(minHeight: 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'כתובת מייל'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'כתובת מייל לא חוקית';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'סיסמה'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'הסיסמה קצרה מידי';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                  
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                   ElevatedButton(
                    child:
                      Text('התחבר', style: TextStyle(color: Theme.of(context).primaryTextTheme.button.color,),),
                    onPressed: _submit,
                    style: 
                      ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                    // padding:
                    //     EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    // color: Theme.of(context).primaryColor,
                    // textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                 ElevatedButton(
                  child: Text('עדיין אין לך חשבון? הירשם', style: TextStyle(color: Theme.of(context).primaryColor,)),
                  onPressed: () {
                    if(authProvider.authMode == AuthMode.CUSTOMER) {
                       Navigator.of(context).pushNamed(RegistrationScreen.routeName);
                    }
                    else {
                      Navigator.of(context).pushNamed(RegisterationExplenationScreen.routeName);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                  )
                  //padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                 // textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
