import 'package:Appo/models/customer.dart';

class Appointment {
  DateTime startTime;
  DateTime endTime;
  Customer client;

  Appointment({this.startTime, this.endTime, this.client});

}