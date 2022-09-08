import 'dart:io';
import 'package:Appo/models/business.dart';
import 'package:Appo/models/user.dart';

class Customer extends User{
  File _image;
  List<Business> _favoriteBusiness;
  
  Customer(userId, email, password, name, address, city, phoneNumber) 
    : super(userId: userId, email: email, password: password, name: name, phoneNumber: phoneNumber, address: address, city: city);

  File get image {
    return _image;
  }

  void set image(File imageToSet) {
    _image = imageToSet;
  }

  List<Business> get favoriteBusiness {
    return _favoriteBusiness;
  }

   factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      json['userId'],
      json['email'], 
      json['password'], 
      json['name'], 
      json['address'], 
      json['city'], 
      json['phone number']
    );
  }

  // factory Customer.fromJson(Map<String, dynamic> json) {
  //   return Customer(json.keys.first, json.keys.first, json['email'], json['name'], json['address'], json['city'], json['phone number']
  //   );
  // }
}

