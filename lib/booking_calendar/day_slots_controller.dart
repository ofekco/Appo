import 'package:Appo/booking_calendar/model/time_slot.dart';
import 'package:Appo/booking_calendar/model/booking.dart';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:flutter/material.dart';

class DaySlotsController extends ChangeNotifier {

  //TimeSlots businessTimesSlots;

  DaySlotsController({@required this.date, @required this.businessId})
  {
    getTimesFromDB();
  }

  DateTime date;
  final int businessId;
  //DateTime get Date => date;
  List<TimeSlot> times;
  
  List<DateTime> _allBookingSlots = [];
  List<DateTime> get allBookingSlots => _allBookingSlots;

  List<DateTimeRange> bookedSlots = [];

  int _selectedSlot = (-1);
  bool _isUploading = false;

  int get selectedSlot => _selectedSlot;
  bool get isUploading => _isUploading;

  Future<void> getTimesFromDB() async {
    times = await DB_Helper.getTimes(businessId, date);
    _generateBookingSlots();
    notifyListeners();
  }

  void _generateBookingSlots() {
    allBookingSlots.clear();
    _allBookingSlots = times.map((e) => e.startTime).toList(); //generate all slots

    times.forEach((e) {
      if(e.isBooked) {
        bookedSlots.add(DateTimeRange(start: e.startTime, end: e.endTime));
      }
    }); //generate booked slots
  }

  bool isSlotBooked(int index) {
    DateTime checkSlot = allBookingSlots.elementAt(index);
    bool result = false;
    for (var slot in bookedSlots) {
      if (slot.start == checkSlot)
      {
        result=true;
        break;
      }
    }
    return result;
  }

  void selectSlot(int idx) {
    _selectedSlot = idx;
    notifyListeners();
  }

  void resetSelectedSlot() {
    _selectedSlot = -1;
    notifyListeners();
  }

  void toggleUploading() {
    _isUploading = !_isUploading;
    notifyListeners();
  }

  // Future<void> generateBookedSlots() {
  //   bookedSlots.clear();
  //   _generateBookingSlots();

  //   for (var i = 0; i < data.length; i++) {
  //     final item = data[i];
  //     bookedSlots.add(item);
  //   }
  // }

  Booking createNewBooking() {
    final bookingDatetime = allBookingSlots.elementAt(selectedSlot);
    Booking newAppo = Booking(
      businessId: businessId,
      date: bookingDatetime, 
      startTime: bookingDatetime, 
      endTime: bookingDatetime.add(Duration(minutes: 60)));
    
    return newAppo;
  }

  Future<dynamic> uploadBooking() async {
    Booking newBooking = createNewBooking();

    await DB_Helper.uploadNewBooking(newBooking.businessId, 
      0, newBooking.date, 
      newBooking.startTime, newBooking.endTime);
      //.then((res) {
      times[selectedSlot].isBooked = true;
      notifyListeners();
    //});
  }
}
