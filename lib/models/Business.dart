import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:Appo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Business extends User with ChangeNotifier {
  Uint8List base64image;
  File _image;
  String imageUrl;
  String serviceType;
  final double latitude;
  final double longitude;
  String instagramUrl;
  bool isFavorite = false;

  Business(
      {String userId,
      String email,
      String password,
      String name,
      String phone,
      String address,
      String city,
      this.serviceType,
      this.imageUrl,
      this.latitude,
      this.longitude,
      this.instagramUrl})
      : super(
            userId: userId,
            email: email,
            password: password,
            name: name,
            phoneNumber: phone,
            address: address,
            city: city) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      base64image = base64Decode(imageUrl);
    }
  }

  File get image {
    return _image;
  }

  void set image(File imageToSet) {
    _image = imageToSet;
    base64image = _image.readAsBytesSync();
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      userId: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      phone: json['phone number'] as String,
      imageUrl: json['imageUrl'] as String,
      serviceType: json['type'] as String,
      latitude: double.tryParse(json['latitude']),
      longitude: double.tryParse(json['longitude']),
      instagramUrl: json['instagram'],
    );
  }

  void toggleFavoriteStatus(String userId) {
    isFavorite = !isFavorite;
    if (isFavorite == true) {
      DB_Helper.postFavorite(userId, this);
    } else {
      DB_Helper.removeFromFavorites(userId, this);
    }
    notifyListeners();
  }

  void updateImage() async {
    if (_image != null) {
      var bytes = await _image.readAsBytes();
      var base64img = base64Encode(bytes);
      await DB_Helper.updateBusinessImage(super.userId, base64img);
    }
  }
}
