import 'dart:convert';
import 'dart:io';
import 'package:Appo/models/authentication.dart';
import 'package:Appo/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/curve_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:http/http.dart' as http;
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
  bool isEditable = false;
    
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SingleChildScrollView(child: 
            Column(children: <Widget>[
              Container(
                width: size.width,
                height: size.height,
                color: Colors.white,
                child: CustomPaint(
                painter: CurvePainter(),
                  child: Column(
                    children: [
                    SizedBox(
                      height: size.height*0.17,
                    ),
                    //image
                    buildProfileImage(size),
                    SizedBox(height: 10),
                    //customer name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children:[
                        Text(widget._currentUser.name, style: 
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28, letterSpacing: 1.15),
                        ),
                      ], 
                    ),
                    //details
                    SizedBox(height: 30),
                    buildPersonalInfo(),
                  ],
                ),
                ),
              ),  
          ]
        )
      )
    )
  );        
}


 Future<void> _getImage() async {
    var imageFile;
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
        title: const Text('בחר אפשרות'),
        actions: <Widget>[
          ListTile(
            title: const Text('צלם תמונה'),
            onTap: () async {
              imageFile = await _openCamera(context);
          }),
          ListTile(
            title: const Text('גלריה'),
            onTap: () async {
              imageFile = await _openGallery(context);
            }),  
          ],
        );   
      }
    );
    
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/${fileName}');
    widget._currentUser.image = savedImage;

     setState(() {
      _shownImage = widget._currentUser.image;
      });
    }

    Future<File> _openCamera(BuildContext context) async {
      final _pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera, maxWidth: 600);

      if (_pickedFile == null) {
        return null;
      }

      Navigator.pop(context);
      return File(_pickedFile.path);
    }

    Future<File> _openGallery(BuildContext context) async {
      final _pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 600);

      if (_pickedFile == null) {
        return null;
      }  

      Navigator.pop(context);
      return File(_pickedFile.path);
    }

  Widget buildProfileImage(var size) {
    _shownImage = widget._currentUser.image != null ? FileImage(widget._currentUser.image)
          : AssetImage('assets/images/client.jpg');

   return Container(
    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
     child: CircleAvatar(
      radius: size.width*0.22,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: size.width*0.2, 
        backgroundImage: _shownImage as ImageProvider,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(110, 110, 0, 0),
          child: MaterialButton(
            onPressed: _getImage,
            color: Colors.blueGrey,
            textColor: Colors.white,
            child: Icon(
              Icons.camera_alt,
              size: 26,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          ),  
        ),
      ),
    ),
  );
}

  Widget buildPersonalInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: isEditable == true ? Icon(Icons.save) : Icon(Icons.edit),
                  onPressed: () {
                    if(isEditable == true) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isEditable == true ? TextFormField(
                initialValue: widget._currentUser.email,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                    color: Colors.black
                    )
                  )
                ),
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
                }): Text(widget._currentUser.email,
                  style: TextStyle(fontSize: 18)),
                
                SizedBox(width: 15,),
                Icon(Icons.email_outlined),  
            ]
          ), 
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isEditable == true ? TextFormField(
               initialValue: widget._currentUser.phoneNumber,
                keyboardType: TextInputType.number,
                showCursor: true,
                decoration: InputDecoration(
                  border: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                    color: Colors.black
                    )
                  )
                ),
                onSaved: (value) {
                  widget._currentUser.phoneNumber = value; 
                }): Text(widget._currentUser.phoneNumber,
                style: TextStyle(fontSize: 18)),
              SizedBox(width: 15,),
              Icon(Icons.phone_outlined),             
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isEditable == true ? Column(
                children: [
                  TextFormField(
                    initialValue: widget._currentUser.city,
                    showCursor: true,
                    decoration: InputDecoration(
                     border: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                      color: Colors.black
                    )
                  )
                ),
                    onSaved: (value) {
                      widget._currentUser.city = value;
                  }),
                  TextFormField(
                    initialValue: widget._currentUser.address,
                    showCursor: true,
                    decoration: InputDecoration(
                      border: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                        color: Colors.black
                    )
                  )
                ),
                    onSaved: (value) {
                      widget._currentUser.address = value; 
                  }),
                ],
              )
              : Text(widget._currentUser.city + ", " + widget._currentUser.address,
                style: TextStyle(fontSize: 18)),
            SizedBox(width: 15,),
            Icon(Icons.home_outlined),             
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateDataInDB() async {
    String _userId = widget._currentUser.userId;
    DatabaseReference firebaseDB = FirebaseDatabase.instance.ref('https://appo-ae26e-default-rtdb.firebaseio.com/customers/${_userId}');

    try {
      await firebaseDB.update({
        'email': widget._currentUser.email,
        'phoneNumber': widget._currentUser.phoneNumber,
        'address': widget._currentUser.address,
        'city': widget._currentUser.city });
    } catch (error) {
      throw error;
    }

    
     try {
      var authInstance =  Provider.of<Authentication>(context);
      var response = await http.post(Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyAV3px-slgo-jPGEgUJBYJbDaTledtXIj8'), 
      body: json.encode(
          {
            'idToken':authInstance.token,
            'email': widget._currentUser.email,
            'returnSecureToken': true,
          },
      ),);
      var responseData = json.decode(response.body);
        if(responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
        
      authInstance.token = responseData['idToken'];
      authInstance.expiryDate = responseData['expiresIn'];
  
    } catch (error) {
      throw error;
    }
  }
}





