import 'dart:io';
import 'package:Appo/models/Business.dart';
import 'package:flutter/material.dart';

class Customer{
  final String _userId; 
  String _firebaseToken;
  String _name;
  String _email;
  String _phoneNumber;
  String _address;
  String _city;
  File _image;
  List<Business> _favoriteBusiness;
  
  Customer(this._userId, this._firebaseToken, this._email, this._name, this._address, this._city, this._phoneNumber);


  String get userId {
    return _userId;
  }

  String get firebaseToken {
    return _firebaseToken;
  }

  String get name {
    return _name;
  }

  void set name(String newName) {
     _name = newName; 
  }

  String get email {
    return _email;
  }

  void set email(String newEmail) {
     _email = newEmail; 
  }

  String get address {
    return _address;
  }

   void set address(String newAddress) {
     _address = newAddress; 
  }

  String get city {
    return _city;
  }

   void set city(String newCity) {
     _city = newCity; 
  }

  String get phoneNumber {
    return _phoneNumber;
  }

   void set phoneNumber(String newNumber) {
     _phoneNumber = newNumber; 
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

}

