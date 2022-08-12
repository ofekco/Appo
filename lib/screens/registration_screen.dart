import 'package:Appo/models/authentication.dart';
import 'package:Appo/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import 'auth_screen.dart';


class RegistrationScreen extends StatefulWidget {
  static const routeName = '/register';
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Map<String, String> _registrationData = {
    'email': '',
    'password': '',
    'name': '',
    'phone number': '',
    'address': '',
    'city': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text('התרחשה שגיאה'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
    );
  }

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
      await Provider.of<Authentication>(context, listen: false)
      .signup(_registrationData['email'], _registrationData['password'], _registrationData['name'],
      _registrationData['phone number'], _registrationData['city'],);
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(TabsScreen.routeName);
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

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    FocusNode emailFocusNode = new FocusNode();
    FocusNode passwordFocusNode = new FocusNode();
    FocusNode confirmPasswordFocusNode = new FocusNode();
    FocusNode phoneNumberFocusNode = new FocusNode();
    FocusNode cityFocusNode = new FocusNode();
    FocusNode nameFocusNode = new FocusNode();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('הירשם')),
      body: Container(
        width: (_deviceSize.width * 0.95),
        padding: EdgeInsets.only(left: 20),
        child: Form(
         key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  focusNode: emailFocusNode,
                  decoration: InputDecoration(
                    labelText: 'כתובת מייל', 
                    labelStyle: TextStyle(
	                    color: emailFocusNode.hasFocus ? Colors.blue : Colors.black)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'כתובת מייל לא חוקית';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _registrationData['email'] = value;
                  },
                ),
                TextFormField(
                  focusNode: passwordFocusNode,
                  decoration: InputDecoration(
                    labelText: 'סיסמה',
                    labelStyle: TextStyle(
	                    color: passwordFocusNode.hasFocus ? Colors.blue : Colors.black)),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'הסיסמה קצרה מידי';
                    }
                  },
                  onSaved: (value) {
                    _registrationData['password'] = value;
                  },
                ),
                TextFormField(
                  focusNode: confirmPasswordFocusNode,
                  decoration: InputDecoration(
                    labelText: 'אימות סיסמה',
                    labelStyle: TextStyle(
	                    color: confirmPasswordFocusNode.hasFocus ? Colors.blue : Colors.black)),
                  obscureText: true,
                  validator: (value) {
                          if (value != _passwordController.text) {
                            return 'הסיסמאות לא זהות';
                          }
                  }
                ),
                TextFormField(
                    focusNode: nameFocusNode,
                     decoration: InputDecoration(
                      labelText: 'שם מלא',
                      labelStyle: TextStyle(
	                    color: nameFocusNode.hasFocus ? Colors.blue : Colors.black)),
                      onSaved: (value) {
                        _registrationData['name'] = value;
                      },
                   ),
                TextFormField(
                     focusNode: phoneNumberFocusNode,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                      
                      labelText: 'מספר טלפון',
                      labelStyle: TextStyle(
	                    color: phoneNumberFocusNode.hasFocus ? Colors.blue : Colors.black)),
                     validator: (Value) {
                       //final range = RegExp(r'^[0-9]+$').hasMatch(Value);
                       if(Value.length < 4 && Value.length > 16) {
                         return 'מספר טלפון לא חוקי';
                       }
                       return null;
                     },
                     onSaved: (value) {
                       _registrationData['phone number'] = value;
                     },
                   ),
                    TextFormField(
                    focusNode: cityFocusNode,
                     decoration: InputDecoration(
                      labelText: 'כתובת',
                      labelStyle: TextStyle(
	                    color: cityFocusNode.hasFocus ? Colors.blue : Colors.black)),
                      onSaved: (value) {
                        _registrationData['address'] = value;
                      },
                   ),
                   TextFormField(
                    focusNode: cityFocusNode,
                     decoration: InputDecoration(
                      labelText: 'עיר',
                      labelStyle: TextStyle(
	                    color: cityFocusNode.hasFocus ? Colors.blue : Colors.black)),
                      onSaved: (value) {
                        _registrationData['city'] = value;
                      },
                   ),
                   SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text('הירשם'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                  FlatButton(
                  child: Text('יש לך כבר חשבון? היכנס'),
                  onPressed: () { Navigator.push<dynamic>(context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => AuthScreen(),
                      fullscreenDialog: true));},
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ]),   
          ),
        )
      )
    );
  }
}


                
                

              
                  

                
                    