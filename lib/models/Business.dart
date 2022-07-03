import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum ServiceType {
  Salon, Barber, Doctor
}

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
}

