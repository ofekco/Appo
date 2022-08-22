import 'package:Appo/booking_calendar/day_slots_controller.dart';
import 'package:flutter/material.dart';
import 'package:Appo/booking_calendar/widgets/booking_slot-widget.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Appo/booking_calendar/widgets/common_button.dart';
import 'package:Appo/booking_calendar/widgets/common_card.dart';
import 'package:Appo/booking_calendar/widgets/booking_dialog.dart';
import 'package:intl/intl.dart';

class CreateSlotsCalendar extends StatefulWidget {

  final businessId;

  const CreateSlotsCalendar({Key key, this.businessId}) : super(key: key); //ctor

  @override
  State<CreateSlotsCalendar> createState() => _CreateSlotsCalendarState();
}

class _CreateSlotsCalendarState extends State<CreateSlotsCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _selectedDay;
  DateTime _focusedDay;
  DateTime selectedStart; //the selected hour for start of working day 
  DateTime selectedEnd; //the selected hour for end of working day 
  DateTime selectedBreakStart;
  DateTime selectedBreakEnd;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _focusedDay = now;
    _selectedDay = now;
    selectedStart = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 8, 0);
    selectedEnd = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 20, 0);
  }

  static String formatDateTime(DateTime dt) {
    return DateFormat.Hm().format(dt);
  }

  void selectNewDateRange() {
    //replace controller to another day 
    selectedStart = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 8, 0);
    selectedEnd = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 20, 0);
  }

  List<DropdownMenuItem> _getAllHours() {
    List<DateTime> hours = [];
    for (int i = 8; i <= 20; i++) {
      hours.add(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, i, 0));
      hours.add(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, i, 30));
    }
    return hours.map<DropdownMenuItem<DateTime>>((DateTime value) {
            print(value);
            return DropdownMenuItem<DateTime>(
              value: value,
              child: Text(DateFormat.Hm("he_IL").format(value)),
            );
          }).toList();
  } 

  List<DropdownMenuItem> _getHoursInBetween() {
    List<DateTime> hours = [];
    for (int i = 0; i <= (selectedEnd.difference(selectedStart).inHours)*2; i++) {
      hours.add(selectedStart.add(Duration(minutes: i*30)));
    }
    return hours.map<DropdownMenuItem<DateTime>>((DateTime value) {
            return DropdownMenuItem<DateTime>(
              value: value,
              child: Text(DateFormat.Hm("he_IL").format(value)),
            );
          }).toList();
  } 

  Widget startDropDown()
  {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<DateTime>(
        value: selectedStart,
        onChanged: (DateTime val) {
          selectedStart = val;
          setState(() {
            selectedStart;           
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        items: _getAllHours(),
      ),
    );
  }

  Widget endDropDown()
  {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<DateTime>(
        value: selectedEnd,
        onChanged: (DateTime val) {
          selectedEnd = val;
          setState(() {
            selectedEnd;           
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        items: _getAllHours(),
      ),
    );
  }

  Widget startBreakDropDown()
  {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<DateTime>(
        value: selectedBreakStart,
        onChanged: (DateTime val) {
          selectedBreakStart = val;
          setState(() {
            selectedBreakStart;           
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        items: _getHoursInBetween(),
      ),
    );
  }

  Widget endBreakDropDown()
  {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<DateTime>(
        value: selectedBreakEnd,
        onChanged: (DateTime val) {
          selectedBreakEnd = val;
          setState(() {
            selectedBreakEnd;           
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        items: _getHoursInBetween(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
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
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    direction: Axis.horizontal,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          startDropDown(),
                          Text('שעת התחלה'),
                      ]),

                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          endDropDown(),
                          Text('שעת סיום'),
                      ]),

                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          endBreakDropDown(),
                          Text('עד '),
                          startBreakDropDown(),
                          Text(':זמן הפסקה')
                        ]
                      ),

                    ],
                   ),
                
              const SizedBox(
                    height: 30,
                  ),

              CommonButton(
                text: 'הגדר',
                onTap: () {},
            
          ),]
      ),
    );
  }
}
