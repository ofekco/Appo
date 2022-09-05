//this class represent one booking for appointment
import 'package:flutter/foundation.dart';
class Booking {
  //final int userId;
  final int businessId;
  //final String serviceType;
  DateTime date;
  DateTime startTime;
  DateTime endTime;

  Booking({
    //@required this.userId,
    @required this.businessId,
    //this.serviceType,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
  });

  Booking.fromJson(Map<String, dynamic> json)
      : //userId = json['userId'] as int,
        businessId = json['businessId'],
        date = DateTime.parse(json['date'] as String),
        startTime = DateTime.parse(json['startTime'] as String),
        endTime = DateTime.parse(json['endTime'] as String);
        //serviceType = json['serviceType'] as String;

  Map<String, dynamic> toJson() => {
       // 'userId': userId,
        'businessId': businessId,
        //'serviceType': serviceType,
        'date' : date.toIso8601String(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
  };
}