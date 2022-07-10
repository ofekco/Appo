import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum ServiceType {
  Salon, Barber, Doctor
}

const Map<String, String> DUMMY_TYPES = const {
  'Salon': 'https://www.medinet.co.il/wp-content/uploads/2021/01/%D7%9E%D7%A0%D7%99%D7%A7%D7%95%D7%A8-%D7%A4%D7%93%D7%99%D7%A7%D7%95%D7%A8.jpg',
  'Barber': 'https://www.appointfix.com/blog/wp-content/uploads/2021/12/barber-shop-decor-ideas.jpg',
  'Doctor': 'https://www.clalitsmile.co.il/tm-content/uploads/2021/04/shutterstock_358265852.jpg'
};

class Business {
  final int id;
  final String name;
  final String owner;
  final String city;
  final String address;
  final String phoneNumber;
  final String imageUrl;
  final ServiceType serviceType;

  const Business({
    @required this.id,
    @required this.name,
    @required this.owner,
    @required this.city,
    @required this.address,
    @required this.phoneNumber,
    @required this.imageUrl,
    @required this.serviceType
  });

  String get TypeImage {
    return DUMMY_TYPES[serviceType];
  }

  String get Type {
    switch(serviceType)
    {
      case ServiceType.Salon:
        return 'Salon';
        break;
      case ServiceType.Barber:
        return 'Barber';
        break;
      case ServiceType.Doctor:
        return 'Doctor';
        break;
      default:
        return 'Unknown';
    }
  }
}

