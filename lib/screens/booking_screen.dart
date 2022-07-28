import 'package:Appo/models/colors.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class BookingCalendarScreen extends StatefulWidget {
  const BookingCalendarScreen({Key key}) : super(key: key);

  @override
  State<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  final now = DateTime.now();
  BookingService mockBookingService;

  @override
  void initState() {
    super.initState();
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 60,
        bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
        bookingStart: DateTime(now.year, now.month, now.day, 9, 0));
  }

  Stream<dynamic> getBookingStreamMock(
      {@required DateTime end, @required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {@required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({@required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    DateTime first = now;
    DateTime second = now.add(const Duration(minutes: 55));
    DateTime third = now.subtract(const Duration(minutes: 240));
    DateTime fourth = now.subtract(const Duration(minutes: 500));
    converted.add(
        DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    converted.add(DateTimeRange(
        start: second, end: second.add(const Duration(minutes: 23))));
    converted.add(DateTimeRange(
        start: third, end: third.add(const Duration(minutes: 15))));
    converted.add(DateTimeRange(
        start: fourth, end: fourth.add(const Duration(minutes: 50))));
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('Booking Calendar'),
          ),
          body: Center(
            child: BookingCalendar(
              bookingService: mockBookingService,
              convertStreamResultToDateTimeRanges: convertStreamResultMock,
              getBookingStream: getBookingStreamMock,
              uploadBooking: uploadBookingMock,
              //pauseSlots: generatePauseSlots(),
              pauseSlotText: 'Not Available',
              hideBreakTime: false,
              
              loadingWidget: const Text('Fetching data...'),
              uploadingWidget: const CircularProgressIndicator(),
              locale: 'iw_IL',
              bookingButtonColor: Theme.of(context).primaryColor,
              availableSlotColor: Palette.kToDark[50],
              //availableSlotText: availableSlotText,
              //bookedSlotColor: bookedSlotColor,
              //bookedSlotText: bookedSlotText,
              selectedSlotColor: Theme.of(context).primaryColor,
              //selectedSlotText: selectedSlotText,
              
            ),
          ),
    );
  }
}
