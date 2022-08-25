import 'package:Appo/booking_calendar/model/time_slot.dart';
import 'package:Appo/booking_calendar/model/booking.dart';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:flutter/material.dart';

//The model of the calendar. holds the selected date and the list of slots (free and booked)
class DaySlotsController extends ChangeNotifier {

  DaySlotsController({@required this.date, @required this.businessId})
  {
    getTimesFromDB();
  }

  DateTime date;
  final int businessId;

  List<TimeSlot> times;
  
  List<DateTime> _allBookingSlots = []; //all business slots
  List<DateTime> get allBookingSlots => _allBookingSlots;

  List<DateTimeRange> bookedSlots = []; //the booked slots

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

  Booking createNewBooking() {
    final bookingDatetime = allBookingSlots.elementAt(selectedSlot);
    Booking newAppo = Booking(
      businessId: businessId,
      date: bookingDatetime, 
      startTime: bookingDatetime, 
      endTime: bookingDatetime.add(Duration(minutes: 60)));
    
    return newAppo;
  }

  Future<dynamic> uploadBooking(String clientId) async {
    Booking newBooking = createNewBooking();

    await DB_Helper.uploadNewBooking(newBooking.businessId, 
      clientId, newBooking.date, 
      newBooking.startTime, newBooking.endTime);
      //.then((res) {
    times[selectedSlot].isBooked = true;
    notifyListeners();
    return newBooking;
    //});
  }

  Future<void> uploadBusinessSlot(int businessId, DateTime slot) async
  {
    await DB_Helper.postDateTimeToBusiness(businessId, slot, slot, slot.add(Duration(hours: 1)));
    _allBookingSlots.add(slot);
    notifyListeners();
  }

  Future<void> deleteBusinessSlot() async
  {
    DateTime slot = allBookingSlots.elementAt(selectedSlot);
    await DB_Helper.deleteSlot(businessId, slot);
    _allBookingSlots.remove(slot);
    notifyListeners();
  }
  
}
