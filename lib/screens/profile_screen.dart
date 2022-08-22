import 'dart:io';
import 'package:Appo/models/customer.dart';
import 'package:Appo/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import '../widgets/curve_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;


class ProfileScreen extends StatefulWidget {
  final Customer _currentUser;

  ProfileScreen(this._currentUser);

  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    var _storedImage;
    
  // Future<void> _getImage() async {
  //   var imageFile;
  //   showDialog(
  //     context: context, 
  //     builder: (context) {
  //       return AlertDialog(
  //       title: const Text('בחר אפשרות'),
  //       actions: <Widget>[
  //         ListTile(
  //           title: const Text('צלם תמונה'),
  //           onTap: () async {
  //             await _openCamera(context);
  //         }),
  //         ListTile(
  //           title: const Text('גלריה'),
  //           onTap: () async {
  //             await _openGallery(context);
  //           }),  
  //         ],
  //       );   
  //     }
  //   );

      
  //     if (imageFile == null) {
  //       return;
  //     }
      

  //    setState(() {
  //     _storedImage = imageFile as File;
  //     });

  //     final appDir = await syspath.getApplicationDocumentsDirectory();
  //     final fileName = path.basename(imageFile.path);
  //     final savedImage = await _storedImage.copy('${appDir.path}/${fileName}');
  //     widget._currentUser.image = savedImage;
  //   }

  //   void _openCamera(BuildContext context) async {
  //     final pickedFile = await ImagePicker().pickImage(
  //       source: ImageSource.camera,
  //       maxWidth: 600);

  //     setState(() {
  //       _imageFile = pickedFile;
  //     });

  //     Navigator.pop(context);
  //   }

  //   void _openGallery(BuildContext context) async {
  //     final pickedFile = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       maxWidth: 600);

  //     setState(() {
  //         _imageFile = pickedFile;
  //     });

  //     Navigator.pop(context);
  //   }

  void _selectImage(File pickedImage) {
    _storedImage = pickedImage;
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
                    //buildProfileImage(size),
                    ProfileImage(_selectImage, widget._currentUser),
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

//   Widget buildProfileImage(var size) {
//    return Container(
//     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//      child: CircleAvatar(
//       radius: size.width*0.32,
//       backgroundColor: Colors.white,
//       child: CircleAvatar(
//         radius: size.width*0.30, 
//         backgroundImage: widget._currentUser.image != null ? FileImage(widget._currentUser.image)
//           : AssetImage('assets/images/client.jpg'),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(190, 110, 0, 0),
//           child: MaterialButton(
//             onPressed: _getImage,
//             color: Colors.blueGrey,
//             textColor: Colors.white,
//             child: Icon(
//               Icons.camera_alt,
//               size: 26,
//             ),
//             padding: EdgeInsets.all(16),
//             shape: CircleBorder(),
//           )  
//         ),
//       ),
//     ),
//   );
// }


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
              Text(widget._currentUser.city + ", " + widget._currentUser.address,
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





