import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:Appo/models/Business.dart';
import 'package:Appo/models/user.dart';
import 'package:flutter/material.dart';

class Customer extends User {
  Uint8List base64image;
  File _image;
  List<Business> _favoriteBusiness;

  Customer(userId, email, password, name, address, city, phoneNumber, imageUrl)
      : super(
            userId: userId,
            email: email,
            password: password,
            name: name,
            phoneNumber: phoneNumber,
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

  List<Business> get favoriteBusiness {
    return _favoriteBusiness;
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      json.keys.first,
      json['email'],
      json['password'],
      json['name'],
      json['address'],
      json['city'],
      json['phone number'],
      json['imageUrl'],
    );
  }

  void updateImage() async {
    if (_image != null) {
      var bytes = await _image.readAsBytes();
      var base64img = base64Encode(bytes);
      await DB_Helper.updateCustomerImage(super.userId, base64img);
    }
  }
}
