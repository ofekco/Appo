
import 'package:Appo/Business_side/model/colors.dart';
import 'package:flutter/material.dart';


class BusinessRegistrationScreen1 extends StatefulWidget {
  static const routeName = '/register_business1';
  @override
  State<BusinessRegistrationScreen1> createState() => _BusinessRegistrationScreen1State();
}

class _BusinessRegistrationScreen1State extends State<BusinessRegistrationScreen1> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final _passwordController = TextEditingController();

  final Map<String, String>_registrationData = {
    'name': '',
    'phone number': '',
    'email': '',
    'password':'',
    'address': '',
    'city': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Text('התרחשה שגיאה'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
    );
  }

  //  Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) {
  //     // Invalid!
  //     return;
  //   }
  //   _formKey.currentState!.save();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     await Provider.of<Authentication>(context, listen: false)
  //     .signup(_registrationData['email'], _registrationData['password'], _registrationData['name'],
  //     _registrationData['phone number'], _registrationData['address'], _registrationData['city'],);
  //     Navigator.of(context).pop();
  //     Navigator.of(context).pushNamed(TabsScreen.routeName);
  //   }
  //   on HttpException catch (error) {
  //     var errorMessage = 'ההרשמה נכשלה';
  //     if (error.toString().contains('EMAIL_EXISTS')) {
  //       errorMessage = 'כתובת מייל כבר רשומה';
  //     } else if (error.toString().contains('INVALID_EMAIL')) {
  //       errorMessage = 'כתובת מייל לא חוקית';
  //     } else if (error.toString().contains('WEAK_PASSWORD')) {
  //       errorMessage = 'הסיסמה חלשה מידי';
  //     } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
  //       errorMessage = 'כתובת מייל לא נמצאה';
  //     } else if (error.toString().contains('INVALID_PASSWORD')) {
  //       errorMessage = 'סיסמה לא נכונה';
  //     }
  //     _showErrorDialog(errorMessage);
  //   }
  //   catch(error) {
  //     var errorMessage = 'משהו השתבש, נסה שנית מאוחר יותר';
  //      _showErrorDialog(errorMessage);

  //   }
    
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  Widget buildProfileImage(var size) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 40, 0, 0),
      child: CircleAvatar(
        radius: size.width*0.22,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: size.width*0.2, 
          backgroundImage: AssetImage('assets/images/client.jpg'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(110, 110, 0, 0),
            child: MaterialButton(
              onPressed: () {
                //TODO!!
              },
              color: Colors.blueGrey,
              textColor: Colors.white,
              child: Icon(
                Icons.camera_alt,
                size: 26,
              ),
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            )  
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final _deviceSize = MediaQuery.of(context).size;
    FocusNode emailFocusNode = FocusNode();
    FocusNode passwordFocusNode = FocusNode();
    FocusNode confirmPasswordFocusNode =  FocusNode();
    FocusNode phoneNumberFocusNode = FocusNode();
    FocusNode addressFocusNode = FocusNode();
    FocusNode cityFocusNode = FocusNode();
    FocusNode nameFocusNode = FocusNode();
    
    return Scaffold(backgroundColor: Color.fromARGB(255, 159, 195, 212),
      body: Container(
        width: (_deviceSize.width * 0.95),
        padding: const EdgeInsets.all(20),
        child: Form(
         key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildProfileImage(_deviceSize),
                SizedBox(height: 10,),
                Padding(padding: const EdgeInsets.only(top: 20.0),
                  child: Directionality(textDirection: TextDirection.rtl,
                    child: TextFormField(//owner name
                        focusNode: nameFocusNode,
                        showCursor: true,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'שם העסק',
                          labelStyle: const TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.blue,),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        onSaved: (value) {
                          _registrationData['name'] = value;
                        },
                       ),
                  ),
                ),

                Padding(padding: const EdgeInsets.only(top: 20.0),
                  child: Directionality(textDirection: TextDirection.rtl,
                    child: TextFormField(//phone
                         focusNode: phoneNumberFocusNode,
                         keyboardType: TextInputType.number,
                         showCursor: true,
                         cursorColor: Colors.black,
                         decoration: InputDecoration(
                          labelText: 'מספר טלפון',
                          labelStyle: TextStyle(color: passwordFocusNode.hasFocus ? Colors.blue : Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(color: Colors.blue,),
                          ),
                          enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
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
                  ),
                ),

                Padding(padding: const EdgeInsets.only(top: 20.0),
                  child: Directionality(textDirection: TextDirection.rtl,
                    child: TextFormField(//owner name
                        focusNode: emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        showCursor: true,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'כתובת מייל',
                          labelStyle: const TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.blue,),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        onSaved: (value) {
                          _registrationData['email'] = value;
                        },
                         validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'כתובת מייל לא חוקית';
                          }
                          return null;
                        },
                       ),
                  ),
                ),

                Padding(padding: const EdgeInsets.only(top: 20.0),
                  child: Directionality(textDirection: TextDirection.rtl,
                    child: TextFormField(//phone
                         focusNode: phoneNumberFocusNode,
                         showCursor: true,
                         cursorColor: Colors.black,
                         decoration: InputDecoration(
                          labelText: 'סיסמה',
                          labelStyle: TextStyle(color: passwordFocusNode.hasFocus ? Colors.blue : Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(color: Colors.blue,),
                          ),
                          enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                         validator: (Value) {
                           if(Value.length < 6) {
                             return 'הסיסמה קצרה מידי';
                           }
                           return null;
                         },
                         onSaved: (value) {
                           _registrationData['password'] = value;
                         },
                       ),
                  ),
                ),

                Padding(padding: const EdgeInsets.only(top: 20.0),
                  child: Directionality(textDirection: TextDirection.rtl,
                    child: TextFormField(
                      focusNode: addressFocusNode,
                      showCursor: true,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'כתובת',
                        labelStyle: const TextStyle(color:Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: Colors.blue,),
                        ),
                        enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                        onSaved: (value) {
                          _registrationData['address'] = value;
                        },
                       ),
                  ),
                  ),

                Padding(padding: const EdgeInsets.only(top: 20.0),
                  child: Directionality(textDirection: TextDirection.rtl,
                    child: TextFormField(
                      focusNode: cityFocusNode,
                      showCursor: true,
                      cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'עיר',
                          labelStyle: const TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.blue,),
                        ),
                       enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      onSaved: (value) {
                      _registrationData['city'] = value;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20,),

                if (_isLoading)
                 const CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        const Text('המשך'),
                    onPressed: (){
                      Navigator.of(context).pushNamed('/register2');
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Palette.kToDark[600],
                    textColor: Colors.white
                  ),
              ]),   
          ),
        )
      )
    );
  }
}


                
                

              
                  

                
                    