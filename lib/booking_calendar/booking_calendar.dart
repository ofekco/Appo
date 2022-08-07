import 'package:Appo/booking_calendar/day_slots_controller.dart';
import 'package:Appo/booking_calendar/model/times_slots.dart';
import 'package:Appo/booking_calendar/widgets/booking_slot-widget.dart';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Appo/booking_calendar/widgets/booking_explanation.dart';
import 'package:Appo/models/colors.dart';
import 'package:Appo/booking_calendar/widgets/common_button.dart';
import 'package:Appo/booking_calendar/widgets/common_card.dart';
import 'package:Appo/booking_calendar/widgets/booking_dialog.dart';
import 'package:intl/intl.dart';

class BookingCalendar extends StatefulWidget {

  final businessId;

  const BookingCalendar({Key key, this.businessId}) : super(key: key); //ctor

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  DaySlotsController controller; //selected day controller
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = context.read<DaySlotsController>();
    _focusedDay = now;
    _selectedDay = now;

    //create new day controller
    // TimeSlots slots = TimeSlots(businessId: widget.businessId, date: _selectedDay);
    // print(slots.times);
    // controller = DaySlotsController(businessTimesSlots: slots);
  }

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _selectedDay;
  DateTime _focusedDay;
  //DateTime startOfDay;
  //DateTime endOfDay;

  static String formatDateTime(DateTime dt) {
    return DateFormat.Hm().format(dt);
  }

  void selectNewDateRange() {
    //replace controller to another day (create new controller)
    controller.date = _selectedDay;
    controller.getTimesFromDB();
    controller.resetSelectedSlot();
  }

  @override
  Widget build(BuildContext context) {
    controller = context.watch<DaySlotsController>();

    return Consumer<DaySlotsController>(builder: (_, controller, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: (controller.isUploading || controller.times == null)
            ? const BookingDialog()
            : Column(
                children: [
                  CommonCard(
                    child: TableCalendar(
                      locale: 'iw_IL',
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 1000)),
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

                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    direction: Axis.horizontal,
                    children: [
                      BookingExplanation(
                        color:  Palette.kToDark[50],
                        text: "Available"),
                      BookingExplanation(
                        color: Palette.kToDark[500],
                        text: "Selected"),
                      BookingExplanation(
                        color: Colors.redAccent,
                        text: "Booked"),
                    ],
                   ),

                  const SizedBox(height: 8),
                      Expanded(
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.allBookingSlots.length,
                          itemBuilder: (context, index) {
                            final slot =
                                controller.allBookingSlots.elementAt(index);

                            return BookingSlot(
                              isBooked: controller.isSlotBooked(index),
                              isSelected: index == controller.selectedSlot,
                              onTap: () => controller.selectSlot(index),
                              child: Center(
                                child: Text(formatDateTime(slot)),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.5,
                          ),
                        ),
                      ),
                    
                  
                  const SizedBox(
                    height: 16,
                  ),

                  CommonButton(
                    text: 'BOOK',
                    onTap: () async {
                      controller.toggleUploading();
                      await controller.uploadBooking();
                      controller.toggleUploading();

                      setState(() {
                        controller.resetSelectedSlot();
                      });
                    },
                    isDisabled: controller.selectedSlot == -1,
                    buttonActiveColor: Palette.kToDark[800],
                  ),
                ],
              ),
      ),
    );
  }
}
