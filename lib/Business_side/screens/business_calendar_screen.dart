import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

class BusinessCalendarScreen extends StatefulWidget {

  @override
  State<BusinessCalendarScreen> createState() => _BusinessCalendarScreenState();
}

class _BusinessCalendarScreenState extends State<BusinessCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return WeekView(
      controller: EventController(),
      eventTileBuilder: (date, events, boundry, start, end) {
        // Return your widget to display as event tile.
        return Container();
      },

      showLiveTimeLineInAllDays: true, // To display live time line in all pages in week view.
      width: MediaQuery.of(context).size.width, // width of week view.
      minDay: DateTime(2000),
      maxDay: DateTime(2050),
      initialDay: DateTime.now(),
      heightPerMinute: 1, // height occupied by 1 minute time span.
      eventArranger: SideEventArranger(), // To define how simultaneous events will be arranged.
      onEventTap: (events, date) => print(events),
      onDateLongPress: (date) => print(date),
      startDay: WeekDays.sunday, // To change the first day of the week.
    );
  }
}