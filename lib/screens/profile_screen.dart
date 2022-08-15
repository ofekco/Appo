import 'dart:io';
import 'package:Appo/models/customer.dart';
import 'package:flutter/material.dart';
import '../widgets/curve_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;


class ProfileScreen extends StatefulWidget {
  Customer _currentUser;

  ProfileScreen(this._currentUser);

  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _takePicture() async {
    var imageFile;
    showDialog(
      context: context, 
      builder: (context) {
        return SimpleDialog(
          title: const Text('בחר אפשרות'),
          children: <Widget>[
           SimpleDialogOption(
            child: const Text('צלם תמונה'),
            onPressed: () async { 
              imageFile = await ImagePicker().pickImage(
               source: ImageSource.camera,
               maxWidth: 600,
              ); 
            }),
           SimpleDialogOption(
            child: const Text('גלריה'),
            onPressed: () async { 
              imageFile = await ImagePicker().pickImage(
              source: ImageSource.gallery,
              maxWidth: 600,); 
            }),
          ],
        );   
      }
    );

   
    setState(() {
     widget._currentUser.image = imageFile as File;
    });
    
  }

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
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26, letterSpacing: 1.15),
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


  Widget buildProfileImage(var size) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: CircleAvatar(
        radius: size.width*0.32,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: size.width*0.30, 
          backgroundImage: AssetImage('assets/images/client.jpg'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(190, 110, 0, 0),
            child: MaterialButton(
              onPressed: _takePicture,
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
                  icon: Icon(Icons.edit),
                  onPressed: () {}, 
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
              Text(widget._currentUser.email,
                style: TextStyle(fontSize: 18)),
              SizedBox(width: 15,),
              Icon(Icons.email_outlined),             
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget._currentUser.phoneNumber,
                style: TextStyle(fontSize: 18)),
              SizedBox(width: 15,),
              Icon(Icons.phone_outlined),             
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget._currentUser.address + ", " + widget._currentUser.city,
                style: TextStyle(fontSize: 18)),
              SizedBox(width: 15,),
              Icon(Icons.home_outlined),             
            ],
          ),
        ],
      ),
    );
  }
}





