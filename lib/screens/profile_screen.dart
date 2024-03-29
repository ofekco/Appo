import 'dart:convert';
import 'dart:io';
import 'package:Appo/models/authentication.dart';
import 'package:Appo/models/customer.dart';
import 'package:Appo/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/curve_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/customer_profile';
  final Customer _currentUser;

  ProfileScreen(this._currentUser);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _shownImage;
  var isEditable = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: CustomPaint(
          painter: CurvePainter(),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.17,
              ),
              //image
              ProfileImage(widget._currentUser),
              SizedBox(height: 10),
              //customer name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Name
                  Text(
                    widget._currentUser.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 1.15),
                  ),
                ],
              ),
              //details
              SizedBox(height: 30),
              Expanded(child: buildPersonalInfo()),
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildPersonalInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          //title and save/edit icon
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon:
                      isEditable == true ? Icon(Icons.save) : Icon(Icons.edit),
                  onPressed: () {
                    if (isEditable == true) {
                      _updateDataInDB();
                    }
                    setState(() {
                      isEditable = !isEditable;
                    });
                  },
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'פרטים אישיים',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          //email
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            isEditable == true
                ? Expanded(
                    child: SizedBox(
                      width: 200,
                      height: 100,
                      child: TextFormField(
                        //textDirection: TextDirection.rtl,
                        initialValue: widget._currentUser.email,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.black))),
                        showCursor: true,
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'כתובת מייל לא חוקית';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          widget._currentUser.email = value;
                        },
                      ),
                    ),
                  )
                : Text(widget._currentUser.email,
                    style: TextStyle(fontSize: 18)),
            SizedBox(
              width: 15,
            ),
            Icon(Icons.email_outlined),
          ])),

          //phone number
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isEditable == true
                    ? Expanded(
                        child: SizedBox(
                          height: 100,
                          width: 200,
                          child: TextFormField(
                              textDirection: TextDirection.rtl,
                              initialValue: widget._currentUser.phoneNumber,
                              keyboardType: TextInputType.number,
                              showCursor: true,
                              decoration: InputDecoration(
                                  border: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black))),
                              onSaved: (value) {
                                widget._currentUser.phoneNumber = value;
                              }),
                        ),
                      )
                    : Text(widget._currentUser.phoneNumber,
                        style: TextStyle(fontSize: 18)),
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.phone_outlined),
              ],
            ),
          ),

          //city
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isEditable == true
                    ? Expanded(
                        child: SizedBox(
                          height: 100,
                          width: 200,
                          child: TextFormField(
                              textDirection: TextDirection.rtl,
                              initialValue: widget._currentUser.city,
                              showCursor: true,
                              decoration: InputDecoration(
                                  border: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black))),
                              onSaved: (value) {
                                widget._currentUser.city = value;
                              }),
                        ),
                      )
                    : Text(widget._currentUser.city,
                        style: TextStyle(fontSize: 18)),
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.location_city),
              ],
            ),
          ),

          //address
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            isEditable == true
                ? Expanded(
                    child: SizedBox(
                      height: 100,
                      width: 200,
                      child: TextFormField(
                          textDirection: TextDirection.rtl,
                          initialValue: widget._currentUser.address,
                          showCursor: true,
                          decoration: InputDecoration(
                              border: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black))),
                          onSaved: (value) {
                            widget._currentUser.address = value;
                          }),
                    ),
                  )
                : Text(widget._currentUser.address,
                    style: TextStyle(fontSize: 18)),
            SizedBox(
              width: 15,
            ),
            Icon(Icons.home_outlined),
          ])),
        ],
      ),
    );
  }

  Future<void> _updateDataInDB() async {
    String _userId = widget._currentUser.userId;
    //await Firebase.initializeApp();
    DatabaseReference firebaseDB = await FirebaseDatabase.instance.ref(
        'https://appo-ae26e-default-rtdb.firebaseio.com/customers/${_userId}');

    try {
      await firebaseDB.update({
        'email': widget._currentUser.email,
        'phoneNumber': widget._currentUser.phoneNumber,
        'address': widget._currentUser.address,
        'city': widget._currentUser.city
      });
    } catch (error) {
      throw error;
    }

    try {
      var authInstance = Provider.of<Authentication>(context);
      var response = await http.post(
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyAV3px-slgo-jPGEgUJBYJbDaTledtXIj8'),
        body: json.encode(
          {
            'idToken': authInstance.token,
            'email': widget._currentUser.email,
            'returnSecureToken': true,
          },
        ),
      );
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      authInstance.token = responseData['idToken'];
      authInstance.expiryDate = responseData['expiresIn'];
    } catch (error) {
      throw error;
    }
  }
}
