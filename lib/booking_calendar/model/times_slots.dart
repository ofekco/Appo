import 'package:Appo/helpers/DB_helper.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import './time_slot.dart';

//this class represents the business time slots for 1 day

class TimeSlots {
  final String businessId;
  //final String serviceType;
  DateTime date;
  List<TimeSlot> times;

  TimeSlots({this.businessId, this.date}) {
    //getTimesFromDB();
  }

  void getTimesFromDB() async {
    times = await DB_Helper.getTimes(businessId, date);
    print(times);
  }

  void getMockData()
  {
    times = [
        TimeSlot(startTime: DateTime(2022, 8, 4, 11, 0, 0),
        endTime: DateTime(2022, 8, 4, 12, 0, 0),
        isBooked: false),

        TimeSlot(startTime: DateTime(2022, 8, 4, 12, 0, 0),
        endTime: DateTime(2022, 8, 4, 13, 0, 0),
        isBooked: false),

      ];
  }

  TimeSlots.fromJson(Map<String, dynamic> json)
      : businessId = json['businessId'] as String,
        times = (json as List).map((val) => TimeSlot.fromJson(val)).toList(),
        date =  DateTime.parse(json['date'] as String);

  Map<String, dynamic> toJson() => {
        'businessId': businessId,
        'date': date,
        'times': jsonEncode(times),
  };
}

