import 'package:intl/intl.dart';

class TimeSlot {
  DateTime startTime;
  DateTime endTime;
  bool isBooked;
  int userId;

  TimeSlot({this.startTime, this.endTime, this.isBooked});

  TimeSlot.fromJson(Map<String, dynamic> json)
      : startTime = DateTime.parse(json['startTime'] as String),
        endTime = DateTime.parse(json['endTime'] as String),
        isBooked = json['isBooked'] as bool,
        userId = json['userId'];
  
  Map<String, dynamic> toJson() => {
        'startTime': startTime,
        'endTime': endTime,
        'isBooked': isBooked,
        'userId' : userId,
  };
}