import 'package:Appo/booking_calendar/day_slots_controller.dart';
import 'package:Appo/booking_calendar/widgets/booking_confirmation.dart';
import 'package:Appo/booking_calendar/widgets/booking_slot-widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Appo/booking_calendar/widgets/booking_explanation.dart';
import 'package:Appo/models/colors.dart';
import 'package:Appo/booking_calendar/widgets/common_button.dart';
import 'package:Appo/booking_calendar/widgets/common_card.dart';
import 'package:Appo/booking_calendar/widgets/booking_dialog.dart';
import 'package:intl/intl.dart';
import 'model/booking.dart';

//This widget is the booking calendar in client side
class BookingCalendar extends StatefulWidget {

  final businessId;
  final clientId;

  const BookingCalendar({Key key, this.businessId, this.clientId}) : super(key: key); //ctor

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
  }

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _selectedDay;
  DateTime _focusedDay;

  static String formatDateTime(DateTime dt) {
    return DateFormat.Hm().format(dt);
  }

  void selectNewDateRange() {
    //replace controller to another day 
    controller.date = _selectedDay;
    controller.getTimesFromDB();
    controller.resetSelectedSlot();
  }

  Widget showAreYouSureAlertDialog(BuildContext ctx)
  {
    return AlertDialog(
      alignment: Alignment.topRight,
      title: Icon(Icons.report, 
        color: Palette.kToDark[50], size: 50,),
        content: Text('?בטוח שאת/ה רוצה להזמין את התור', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Palette.kToDark[500]), ),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            }, 
            child: Text('לא', style: TextStyle(color: Colors.white),)
          ),

          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Palette.kToDark[500]), ),
            child: Text('כן', style:TextStyle(color: Colors.white)),
            onPressed: () {
              onBookButtonTap(context);
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      );
  }

  Widget showErrorAlertDialog(BuildContext ctx, String errText)
  {
    return AlertDialog(
      alignment: Alignment.topRight,
      title: Icon(Icons.report, 
        color: Palette.kToDark[50], size: 50,),
        content: Text(errText, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Palette.kToDark[500]), ),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            }, 
            child: Text('הבנתי', style: TextStyle(color: Colors.white),)
          ),

        ],
      );
  }

  void onBookButtonTap(BuildContext ctx) async
  {
    controller.toggleUploading();
    Booking book = await controller.uploadBooking(widget.clientId);
    controller.toggleUploading();

    if(book != null)
    {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: ctx,
        builder: (_) {
          return BookingConfirmation(book);
        },
      );
    }
    else {
      showDialog(
        context: ctx,
        builder: (_) {
          return showErrorAlertDialog(ctx, 'התור הזה כבר נתפס');
        },
      );
    }
    
    setState(() {
        controller.resetSelectedSlot();
    });   
    
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
                      lastDay: DateTime.now().add(const Duration(days: 35)),
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
                        text: "זמין"),
                      BookingExplanation(
                        color: Palette.kToDark[500],
                        text: "נבחר"),
                      BookingExplanation(
                        color: Colors.redAccent,
                        text: "לא זמין"),
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
                text: 'הזמן',
                onTap: () => showDialog(
                              context: context, 
                              builder: (ctx) => 
                                controller.isValidBooking(widget.clientId) ? 
                                  showAreYouSureAlertDialog(ctx)
                                  : showErrorAlertDialog(ctx, 'כבר קיימת הזמנה לאותו יום')
                            ),
                isDisabled: controller.selectedSlot == -1,
                buttonActiveColor: Palette.kToDark[800],
              ),
            ],
          ),
      ),
    );
  }
}