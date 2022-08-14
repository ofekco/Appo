import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:http/http.dart' as http;
import 'package:Appo/booking_calendar/model/time_slot.dart';
import 'package:Appo/helpers/DB_helper.dart';
class BusinessCalendarScreen extends StatefulWidget {
  int businessID = 3;

  @override
  State<BusinessCalendarScreen> createState() => _BusinessCalendarScreenState();
}

class _BusinessCalendarScreenState extends State<BusinessCalendarScreen> {
  List<CalendarEventData<TimeSlot>> _appointments = [];
  bool isLoading = true;

  void initState()
  {
    super.initState();
    getSlots();
  }

  //get slots as json file - map of dates
  Future<void> getSlots() async 
  {
    final url = Uri.parse('https://appo-ae26e-default-rtdb.firebaseio.com/businesses/${widget.businessID}/times.json');
    try {
      http.Response response = await http.get(url);
      var jsonData = jsonDecode(response.body) as Map;
    
      for(var itemKey in jsonData.keys)
      {
        DateTime date = DB_Helper.convertDateKeyToDate(itemKey);
        if(jsonData[itemKey] != null)
        {
          await addDateApposToCalendar(date, jsonData[itemKey]);
        }
      }

      setState(() {
      isLoading = false;
      });
    }
    catch(err) {
      print(err);
      throw err;
    }
  }

  Future<void> addDateApposToCalendar(DateTime date, Map json) async
  {
    for(var timeKey in json.keys)
    {
      DateTime time = DB_Helper.convertDateTimeKeyToDateTime(timeKey);
      if(json[timeKey] != null)
      {
        if(json[timeKey]['isBooked'] as bool == true)
        {
          TimeSlot t = TimeSlot.fromJson(json[timeKey]);
          Map user = await DB_Helper.findCustomerById(t.userId);
          String name = user['name'];
          createEvent(t, name);
        }
      }
    }
  }

  void createEvent(TimeSlot booking, String userName)
  {
    CalendarEventData<TimeSlot> event = 
      CalendarEventData(
      date: booking.startTime,
      event: booking,
      title: userName,
      description: "",
      startTime: booking.startTime,
      endTime: booking.endTime,
      );

    _appointments.add(event);
  }

  void onEventTap(List<CalendarEventData<dynamic>> event)
  {
    showDialog(context: context, builder: (context) => 
      AlertDialog(
        title: Text(event.first.title,),
        content: Text(event.first.startTime.toString()),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('סגור'))
            ],
      ),);
  }


  @override
  Widget build(BuildContext context) {
    return  isLoading ? Container(child: Text('loading'),) :
    WeekView(
      controller: CalendarControllerProvider.of(context).controller..addAll(_appointments), 
      showLiveTimeLineInAllDays: true, // To display live time line in all pages in week view.
      width: MediaQuery.of(context).size.width, // width of week view.
      minDay: DateTime(2000),
      maxDay: DateTime(2050),
      initialDay: DateTime.now(),
      heightPerMinute: 1, // height occupied by 1 minute time span.
      eventArranger: SideEventArranger(), // To define how simultaneous events will be arranged.
      onEventTap: (event, date) => onEventTap(event),
      startDay: WeekDays.sunday,
      eventTileBuilder: (date, event, boundry, start, end) {
        return 
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.blue,
                ),
                child: Center(
                  child: Text(event.first.title,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
            ),
            onDoubleTap: () => onEventTap(event),
        );
      }
    );
  }
}