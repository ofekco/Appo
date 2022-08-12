import 'dart:io';

import 'package:Appo/models/Business.dart';
import 'package:flutter/material.dart';

class Customer {
  final String _userId; 
  String _firebaseToken;
  String _name;
  String _email;
  String _phoneNumber;
  String _city;
  String _imageUrl;
  File _image;
  List<Business> _favoriteBusiness;
  

  Customer(this._userId, this._firebaseToken, this._email);

  String get userId {
    return _userId;
  }

  String get name {
    return _name;
  }

  String get email {
    return _email;
  }

  String get city {
    return _city;
  }

  String get phoneNumber {
    return _phoneNumber;
  }

  File get image {
    return _image;
  }

  void set image(File imageToSet) {
    _image = imageToSet;
  }

  List<Business> get favoriteBusiness {
    return _favoriteBusiness;
  }

  void importCustomerDataFromDB(String userId) {

  }

}

