import 'dart:io';
import 'package:Appo/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ProfileImage extends StatefulWidget {
  final Function onSelectImage;
  final Customer _currentCustomer;

  ProfileImage(this.onSelectImage, this._currentCustomer);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File _storedImage;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
     child: CircleAvatar(
      radius: size.width*0.32,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: size.width*0.30, 
        backgroundImage: widget._currentCustomer.image != null ? FileImage(widget._currentCustomer.image)
          : AssetImage('assets/images/client.jpg'),
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
              await _openCamera(context, imageFile);
          }),
          ListTile(
            title: const Text('גלריה'),
            onTap: () async {
              await _openGallery(context, imageFile);
            }),  
          ],
        );   
      }
    );

      
      if (imageFile == null) {
        return;
      }

      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final savedImage = await _storedImage.copy('${appDir.path}/${fileName}');
      

     setState(() {
      widget._currentCustomer.image = savedImage;
      _storedImage = savedImage;
      });
  
    }

    void _openCamera(BuildContext context, File imageFile) async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 600);

      setState(() {
        imageFile = File(pickedFile.path);
      });

      Navigator.pop(context);
    }

    void _openGallery(BuildContext context, File imageFile) async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600);

      setState(() {
          imageFile = File(pickedFile.path);
      });

      Navigator.pop(context);
    }
}