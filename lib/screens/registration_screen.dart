import 'package:flutter/material.dart';
import 'auth_screen.dart';


class RegistrationScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register')),
      body: Container(
        child: Form(
         key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                        }
                ),
                TextFormField(
                     decoration: InputDecoration(labelText: 'Phone Number'),
                     obscureText: true,
                     validator: (Value) {
                       final range = RegExp(r'^[0-9]+$').hasMatch(Value);
                       if(!range) {
                         return 'Illegal input!';
                       }
                       return null;
                     } 
                   ),
              ]),
                
                
          ),
        )
      )
    );
  }
}


                
                

              
                  

                
                    