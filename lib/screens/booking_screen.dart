import 'package:Appo/widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../booking_calendar/day_slots_controller.dart';

class BookingCalendarScreen extends StatefulWidget {
  final businessId;
  const BookingCalendarScreen(this.businessId);

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
            child: BookingCalendar(businessId: widget.businessId)
            ),
    ));
  }
}
