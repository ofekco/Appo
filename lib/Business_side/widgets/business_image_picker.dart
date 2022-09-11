import 'dart:io';
import 'package:Appo/models/Business.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class BusinessProfileImage extends StatefulWidget {
  final Business _business;

  BusinessProfileImage(this._business);

  @override
  State<BusinessProfileImage> createState() => _BusinessProfileImageState();
}

class _BusinessProfileImageState extends State<BusinessProfileImage> {
  File _pickedImage;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: CircleAvatar(
        radius: size.width * 0.32,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: size.width * 0.30,
          backgroundImage: widget._business.base64image != null
              ? MemoryImage(widget._business.base64image)
              : AssetImage('assets/images/client.jpg'),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(180, 140, 0, 0),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueGrey,
                child: IconButton(
                  alignment: Alignment.center,
                  onPressed: _getImage,
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: Icon(
                    Icons.camera_alt,
                    size: 30,
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    //var imageFile;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('בחר אפשרות'),
            actions: <Widget>[
              ListTile(
                  title: const Text('צלם תמונה'),
                  onTap: () async {
                    await _openCamera(context);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  title: const Text('גלריה'),
                  onTap: () async {
                    await _openGallery(context);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        }).then((_) async {
      if (_pickedImage == null) {
        return;
      }

      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(_pickedImage.path);
      final savedImage = await _pickedImage.copy('${appDir.path}/${fileName}');

      setState(() {
        widget._business.image = savedImage;
        _pickedImage = savedImage;
      });

      await widget._business.updateImage();
    });
  }

  void _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImageFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);

    setState(() {
      if (pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);
      }
    });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 600);

    setState(() {
      if (pickedFile != null) {
        _pickedImage = File(pickedFile.path);
      }
    });
  }
}
