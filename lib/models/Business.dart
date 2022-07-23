import 'package:Appo/models/database_methods.dart';
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
      serviceType: json['serviceType'] as String
    );
  }

  void toggleFavoriteStatus() 
  {
    isFavorite = !isFavorite;
    if(isFavorite == true)
    {
      DatabaseMethods.postFavorite(this);
    }
    else{
      DatabaseMethods.removeFromFavorites(this);
    }
    notifyListeners();
  }
}

