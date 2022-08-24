import 'package:Appo/Business_side/widgets/create_slots_form.dart';
import 'package:Appo/Business_side/widgets/edit_slots_widget.dart';
import 'package:Appo/booking_calendar/day_slots_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Appo/booking_calendar/widgets/booking_dialog.dart';
import 'package:intl/intl.dart';
import '../booking_calendar/widgets/common_card.dart';

//This widget is a wrap widget to add slot or edit slot. 
//The widget contains dates calendar and when the user pick a date - if there are no slots in this date - 
//'Add' widget is loaded, else - 'edit' widget is loaded.

class AddOrEditCalendar extends StatefulWidget {

  final businessId;

  const AddOrEditCalendar({Key key, this.businessId}) : super(key: key); //ctor

  @override
  State<AddOrEditCalendar> createState() => _AddOrEditCalendarState();
}

class _AddOrEditCalendarState extends State<AddOrEditCalendar> {
  DaySlotsController controller; //selected day controller
  final now = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _selectedDay;
  DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    controller = context.read<DaySlotsController>();
    _focusedDay = now;
    _selectedDay = now;
  }

  static String formatDateTime(DateTime dt) {
    return DateFormat.Hm().format(dt);
  }

  void selectNewDateRange() {
    //replace controller to another date
    controller.date = _selectedDay;
    controller.getTimesFromDB();
    controller.resetSelectedSlot();
  }

  @override
  Widget build(BuildContext context) {
    controller = context.watch<DaySlotsController>();

    return Consumer<DaySlotsController>(builder: (_, controller, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: (controller.isUploading || controller.times == null) ?
          const BookingDialog()
          : Column(
            children: [ 
              CommonCard(
                child: TableCalendar(
                      locale: 'iw_IL',
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 30)),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      calendarStyle:
                          const CalendarStyle(isTodayHighlighted: true),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                          selectNewDateRange();
                        }
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
              ),

              const SizedBox(height: 8),
          
           Expanded(
             child: controller.allBookingSlots.isEmpty ?
              CreateSlotsForm(businessId: widget.businessId) 
              : EditSlotsWidget(businessId: widget.businessId),
           )
          ]
        ),                    
      ),
    );
  }
}
