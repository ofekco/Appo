import 'dart:io';
import 'package:Appo/models/business.dart';
import 'package:Appo/models/user.dart';

class Customer extends User{
  // final String _userId; 
  // String _name;
  // String _email;
  // String _phoneNumber;
  // String _address;
  // String _city;
  File _image;
  List<Business> _favoriteBusiness;
  
  Customer(userId, email, password, name, address, city, phoneNumber) 
    : super(userId: userId, email: email, password: password, name: name, phoneNumber: phoneNumber, address: address, city: city);

  // String get userId {
  //   return _userId;
  // }

  // String get firebaseToken {
  //   return _firebaseToken;
  // }

  // String get name {
  //   return _name;
  // }

  // void set name(String newName) {
  //    _name = newName; 
  // }

  // String get email {
  //   return _email;
  // }

  // void set email(String newEmail) {
  //    _email = newEmail; 
  // }

  // String get address {
  //   return _address;
  // }

  //  void set address(String newAddress) {
  //    _address = newAddress; 
  // }

  // String get city {
  //   return _city;
  // }

  //  void set city(String newCity) {
  //    _city = newCity; 
  // }

  // String get phoneNumber {
  //   return _phoneNumber;
  // }

  //  void set phoneNumber(String newNumber) {
  //    _phoneNumber = newNumber; 
  // }
  

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

