import 'package:provider/provider.dart';
import '../booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import '../booking_calendar/day_slots_controller.dart';

class BookingCalendarScreen extends StatefulWidget {
  final businessId;
  final clientId;
  const BookingCalendarScreen(this.businessId, this.clientId);

  @override
  State<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title: const Text('קבע תור')),

          //endDrawer: NavDrawer(),
          body: ChangeNotifierProvider(
          create:(_) =>
            DaySlotsController(businessId: widget.businessId, date: DateTime.now()),

          child: Center(
            child: BookingCalendar(businessId: widget.businessId, clientId: widget.clientId,)
            ),
    ));
  }
}
