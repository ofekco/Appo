import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class User {
  final String userId;
  String email;
  String password;
  String name;
  String phoneNumber;
  String address;
  String city;
  String imageUrl;

  User({
    @required this.userId,
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.phoneNumber,
    @required this.address,
    @required this.city,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  void set imageURL (value) {
    imageUrl = value;
  }
}
