
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Appo/booking_calendar/widgets/common_button.dart';
import 'package:Appo/booking_calendar/widgets/common_card.dart';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:intl/intl.dart';

class CreateSlotsCalendar extends StatefulWidget {
  final START_HOUR = 8;
  final END_HOUR = 20;
  final businessId;

  const CreateSlotsCalendar({Key key, this.businessId}) : super(key: key); //ctor

  @override
  State<CreateSlotsCalendar> createState() => _CreateSlotsCalendarState();
}

class _CreateSlotsCalendarState extends State<CreateSlotsCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _selectedDay; 
  DateTime _focusedDay;
  DateTime selectedStart; //the selected hour for the start of working day 
  DateTime selectedEnd; //the selected hour for the end of working day 
  List<DateTime> selectedBreaksStart = [null, null]; //list of the selected hours for the start of breaks 
  List<DateTime> selectedBreaksEnd = [null, null]; //list of the selected hours for the end of breaks 
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _focusedDay = now;
    _selectedDay = now;
    selectedStart = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, widget.START_HOUR, 0); 
    selectedEnd = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, widget.END_HOUR, 0);
  }

  static String formatDateTime(DateTime dt) {
    return DateFormat.Hm().format(dt);
  }

  void selectNewDateRange() {
    selectedStart = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, widget.START_HOUR, 0);
    selectedEnd = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, widget.END_HOUR, 0);
    selectedBreaksEnd[0]= selectedBreaksEnd[1]=null;
    selectedBreaksStart[0]=selectedBreaksStart[1]=null;
  }

  List<DropdownMenuItem> _getAllHours() {
    List<DateTime> hours = [];
    for (int i = 8; i <= 20; i++) {
      hours.add(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, i, 0)); //שעה עגולה
      hours.add(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, i, 30));// חצי שעה
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

  Widget startBreakDropDown(int breakNumber)
  {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<DateTime>(
        value: selectedBreaksStart[breakNumber],
        onChanged: (DateTime val) {
          selectedBreaksStart[breakNumber] = val;
          setState(() {
            selectedBreaksStart[breakNumber];           
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        items: _getHoursInBetween(),
      ),
    );
  }

  Widget endBreakDropDown(int breakNumber)
  {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<DateTime>(
        value: selectedBreaksEnd[breakNumber],
        onChanged: (DateTime val) {
          selectedBreaksEnd[breakNumber] = val;
          setState(() {
            selectedBreaksEnd[breakNumber];           
          });
        },
        icon: Icon(Icons.arrow_drop_down),
        items: _getHoursInBetween(),
      ),
    );
  }

  void setSlots() async {
    List<DateTime> slots=[];
    for (int i = 0; i < (selectedBreaksStart[0].difference(selectedStart).inHours); i++) {
      slots.add(selectedStart.add(Duration(hours: i)));
    }
    for (int i = 0; i < (selectedBreaksStart[1].difference(selectedBreaksEnd[0]).inHours); i++) {
      slots.add(selectedBreaksEnd[0].add(Duration(hours: i)));
    }
    for (int i = 0; i < (selectedEnd.difference(selectedBreaksEnd[1]).inHours); i++) {
      slots.add(selectedBreaksEnd[1].add(Duration(hours: i)));
    }

    await slots.forEach((slot) {
      DB_Helper.postDateTimeToBusiness(widget.businessId, slot, slot, slot.add(Duration(hours: 1)));
    });
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
                          Text(':תחילת יום עבודה'),
                      ]),

                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          endDropDown(),
                          Text(':סוף יום עבודה'),
                      ]),

                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          endBreakDropDown(0),
                          Text('עד '),
                          startBreakDropDown(0),
                          Text(': הפסקה ראשונה')
                        ]
                      ),

                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          endBreakDropDown(1),
                          Text('עד '),
                          startBreakDropDown(1),
                          Text(': הפסקה שנייה')
                        ]
                      ),
                    ],
                   ),
                
              const SizedBox(
                    height: 30,
                  ),

              CommonButton(
                text: 'הגדר',
                onTap: () =>setSlots(),
            
          ),]
      ),
    );
  }
}
