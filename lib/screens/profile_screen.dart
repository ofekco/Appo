import 'dart:io';
import 'package:flutter/material.dart';
import '../models/authentication.dart';
import '../models/customer.dart';
import '../widgets/curve_painter.dart';
import '../widgets/drawer.dart';
import 'package:image_picker/image_picker.dart';


class ProfileScreen extends StatefulWidget {
  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      Authentication.currentUser.image = imageFile as File;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Container(
            color: Colors.white, //screen background color
          ),
          SingleChildScrollView(child: 
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
                        Text("Authentication.currentUser.name", style: 
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.15),
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
        Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: AppBar(
          title: Text(''),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            ),
          backgroundColor: Colors.transparent, 
          elevation: 0.0, //No shadow
        ),
      ),
      ]
    )
        )]
        )
    ));        
  }


  Widget buildProfileImage(var size) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: CircleAvatar(
        radius: size.width*0.32,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: size.width*0.30, 
          backgroundImage: AssetImage('asset/images/client.png'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(190, 110, 0, 0),
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
              Text(Authentication.currentUser.email,
                style: TextStyle(fontSize: 18)),
              SizedBox(width: 15,),
              Icon(Icons.email_outlined),             
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(Authentication.currentUser.phoneNumber,
                style: TextStyle(fontSize: 18)),
              SizedBox(width: 15,),
              Icon(Icons.phone_outlined),             
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(Authentication.currentUser.address + ", " + Authentication.currentUser.city,
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





