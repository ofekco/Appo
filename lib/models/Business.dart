import 'package:Appo/helpers/DB_helper.dart';
import 'package:Appo/models/type.dart';
import 'package:Appo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Business extends User with ChangeNotifier {
  // final String id;
  // final String name;
  // final String email;
  // final String city;
  // final String address;
  // final String phoneNumber;
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
            city: city);

  // Business({
  //   @required this.id,
  //   @required this.name,
  //   @required this.email,
  //   @required this.city,
  //   @required this.address,
  //   @required this.phoneNumber,
  //   this.imageUrl,
  //   this.serviceType,
  //   this.longitude, this.latitude
  // });

  // factory Business.fromJson(Map<String, dynamic> json) {
  //   return Business(
  //     id: json['id'] as String,
  //     name: json['name'] as String,
  //     city: json['city'] as String,
  //     address: json['address'] as String,
  //     phoneNumber: json['phoneNumber'] as String,
  //     imageUrl: json['imageUrl'] as String,
  //     serviceType: json['serviceType'] as String,
  //     latitude: json['latitude'],
  //     longitude: json['longitude'],
  //   );
  // }

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
}
