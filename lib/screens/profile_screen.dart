import 'dart:convert';
import 'dart:io';
import 'package:Appo/models/customer.dart';
import 'package:Appo/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import '../widgets/curve_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:Appo/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';


class ProfileScreen extends StatefulWidget {
  final Customer _currentUser;

  ProfileScreen(this._currentUser);

  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _shownImage;
  Map<String, bool> isEditable = {
    'email': false,
    'phoneNumber': false,
    'address': false,
  };
    
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
      radius: size.width*0.32,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: size.width*0.30, 
        backgroundImage: _shownImage as ImageProvider,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(190, 110, 0, 0),
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
          )  
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
                  icon: isEditable['email'] == true ? Icon(Icons.save) : Icon(Icons.edit),
                  onPressed: () {
                    
                  }, 
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'פרטים אישיים',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: isEditable['email'] ? Icon(Icons.save_outlined) : Icon(Icons.edit_outlined),
                onPressed: () {
                  setState(() {
                    isEditable['email'] = !isEditable['email'];
                  });
                }),
                isEditable['email'] ? TextFormField(
                  controller: TextEditingController(text: widget._currentUser.email),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'כתובת מייל לא חוקית';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget._currentUser.email = value; 
                    _updateEmailInDB(value);
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
              IconButton(
                icon: isEditable['phoneNumber'] ? Icon(Icons.save_outlined) : Icon(Icons.edit_outlined),
                onPressed: () {
                  setState(() {
                    isEditable['phoneNumber'] = !isEditable['phoneNumber'];
                  });
                }),
                isEditable['phoneNumber'] ? TextField(
                  controller: TextEditingController(text: widget._currentUser.phoneNumber),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    widget._currentUser.phoneNumber = value; 
                    //TODO: a set function in customer that also updates in fireBase
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
               IconButton(
                icon: isEditable['address'] ? Icon(Icons.save_outlined) : Icon(Icons.edit_outlined),
                onPressed: () {
                  setState(() {
                    isEditable['address'] = !isEditable['address'];
                  });
                }),
                isEditable['address'] ? Column(
                  children: [
                    TextField(
                      controller: TextEditingController(text: widget._currentUser.city),
                      onSubmitted: (value) {
                        widget._currentUser.city = value; //TODO: a set function in customer that also updates in fireBase
                    }),
                    TextField(
                      controller: TextEditingController(text: widget._currentUser.address),
                      onSubmitted: (value) {
                        widget._currentUser.address = value; //TODO: a set function in customer that also updates in fireBase
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

  Future<void> _updateEmailInDB(String newEmail) async {
    String _userId = widget._currentUser.userId;
    DatabaseReference firebaseDB = FirebaseDatabase.instance.ref('https://appo-ae26e-default-rtdb.firebaseio.com/customers/${_userId}');

    try {
      await firebaseDB.update({
        'email': newEmail });
    } catch (error) {
      throw error;
    }

    firebaseDB = FirebaseDatabase.instance.ref('https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAV3px-slgo-jPGEgUJBYJbDaTledtXIj8/${_userId}');
     
     try {
      await firebaseDB.update({
        'email': newEmail });
    } catch (error) {
      throw error;
    }
  }
}





