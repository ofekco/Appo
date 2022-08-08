import 'package:Appo/models/authentication.dart';
import 'package:Appo/screens/home_screen.dart';
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
            title: Text('An Error Occurred!'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
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
      // Navigator.push<dynamic>(context,
      //               MaterialPageRoute<dynamic>(
      //                 builder: (BuildContext context) => HomeScreen(),
      //                 fullscreenDialog: true));
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    }
    on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    }
    catch(error) {
      var errorMessage = 'Something went wrong, please try again later';
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
    FocusNode addressFocusNode = new FocusNode();
    FocusNode cityFocusNode = new FocusNode();
    FocusNode nameFocusNode = new FocusNode();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up')),
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
                    labelText: 'E-Mail', 
                    labelStyle: TextStyle(
	                    color: emailFocusNode.hasFocus ? Colors.blue : Colors.black)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
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
                    labelText: 'Password',
                    labelStyle: TextStyle(
	                    color: passwordFocusNode.hasFocus ? Colors.blue : Colors.black)),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _registrationData['password'] = value;
                  },
                ),
                TextFormField(
                  focusNode: confirmPasswordFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
	                    color: confirmPasswordFocusNode.hasFocus ? Colors.blue : Colors.black)),
                  obscureText: true,
                  validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                  }
                ),
                TextFormField(
                    focusNode: nameFocusNode,
                     decoration: InputDecoration(
                      labelText: 'Name',
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
                      
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
	                    color: phoneNumberFocusNode.hasFocus ? Colors.blue : Colors.black)),
                     validator: (Value) {
                       //final range = RegExp(r'^[0-9]+$').hasMatch(Value);
                       if(Value.length < 4 && Value.length > 16) {
                         return 'Illegal input!';
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
                      labelText: 'Address',
                      labelStyle: TextStyle(
	                    color: cityFocusNode.hasFocus ? Colors.blue : Colors.black)),
                      onSaved: (value) {
                        _registrationData['address'] = value;
                      },
                   ),
                   TextFormField(
                    focusNode: cityFocusNode,
                     decoration: InputDecoration(
                      labelText: 'City',
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
                        Text('SIGNUP'),
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
                  child: Text('Already a member? Login'),
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


                
                

              
                  

                
                    