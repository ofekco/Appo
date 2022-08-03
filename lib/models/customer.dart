import 'package:Appo/models/Business.dart';
import 'package:flutter/material.dart';

class Customer {
  final String _userId; 
  String _name;
  String _email;
  String _phoneNumber;
  String _city;
  List<Business> _favoriteBusiness;

  Customer(this._userId);
}
//need to create a customer from fireBase user and save it on the db. 
//need to specipy the request to be of the user logged in 
