import 'package:Appo/helpers/DB_helper.dart';
import 'package:Appo/models/type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Business with ChangeNotifier {
  final int id;
  final String name;
  final String owner;
  final String city;
  final String address;
  final String phoneNumber;
  final String imageUrl;
  final String serviceType;
  final double latitude;
  final double longitude;
  bool isFavorite = false;

  Business({
    @required this.id,
    @required this.name,
    @required this.owner,
    @required this.city,
    @required this.address,
    @required this.phoneNumber,
    @required this.imageUrl,
    @required this.serviceType,
    this.longitude, this.latitude
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as int,
      name: json['name'] as String,
      owner: json['owner'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String,
      imageUrl: json['imageUrl'] as String,
      serviceType: json['serviceType'] as String,
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  void toggleFavoriteStatus() 
  {
    isFavorite = !isFavorite;
    if(isFavorite == true)
    {
      DB_Helper.postFavorite(this);
    }
    else{
      DB_Helper.removeFromFavorites(this);
    }
    notifyListeners();
  }
}

