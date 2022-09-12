import 'package:Appo/booking_calendar/day_slots_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Appo/booking_calendar/widgets/common_button.dart';
import 'package:Appo/booking_calendar/widgets/common_card.dart';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:intl/intl.dart';

class CreateSlotsForm extends StatefulWidget {
  final START_HOUR = 8;
  final END_HOUR = 20;
  final businessId;

  const CreateSlotsForm({Key key, this.businessId}) : super(key: key); //ctor

  @override
  State<CreateSlotsForm> createState() => _CreateSlotsFormState();
}

class _CreateSlotsFormState extends State<CreateSlotsForm> {
  DaySlotsController controller;
  DateTime _selectedDay; //The selected date
  DateTime selectedStart; //the selected hour for the start of working day
  DateTime selectedEnd; //the selected hour for the end of working day
  List<DateTime> selectedBreaksStart = [
    null,
    null
  ]; //list of the selected hours for the start of breaks
  List<DateTime> selectedBreaksEnd = [
    null,
    null
  ]; //list of the selected hours for the end of breaks
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = context.read<DaySlotsController>();
    _selectedDay = controller.date;
    selectedStart = DateTime(_selectedDay.year, _selectedDay.month,
        _selectedDay.day, widget.START_HOUR, 0);
    selectedEnd = DateTime(_selectedDay.year, _selectedDay.month,
        _selectedDay.day, widget.END_HOUR, 0);
  }

  List<DropdownMenuItem> _getAllHours() {
    List<DateTime> hours = [];
    for (int i = 8; i <= 20; i++) {
      hours.add(DateTime(_selectedDay.year, _selectedDay.month,
          _selectedDay.day, i, 0)); //שעה עגולה

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
    for (int i = 0; i <= (selectedEnd.difference(selectedStart).inHours); i++) {
      hours.add(selectedStart.add(Duration(hours: i)));
    }
    return hours.map<DropdownMenuItem<DateTime>>((DateTime value) {
      return DropdownMenuItem<DateTime>(
        value: value,
        child: Text(DateFormat.Hm("he_IL").format(value)),
      );
    }).toList();
  }

  Widget startDropDown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
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

  Widget endDropDown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
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

  Widget startBreakDropDown(int breakNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
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

  Widget endBreakDropDown(int breakNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
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
    List<DateTime> slots = [];
    if (selectedBreaksStart[0] != null && selectedBreaksStart[1] != null) {
      for (int i = 0;
          i < (selectedBreaksStart[0].difference(selectedStart).inHours);
          i++) {
        slots.add(selectedStart.add(Duration(hours: i)));
      }
      for (int i = 0;
          i < (selectedBreaksStart[1].difference(selectedBreaksEnd[0]).inHours);
          i++) {
        slots.add(selectedBreaksEnd[0].add(Duration(hours: i)));
      }
      for (int i = 0;
          i < (selectedEnd.difference(selectedBreaksEnd[1]).inHours);
          i++) {
        slots.add(selectedBreaksEnd[1].add(Duration(hours: i)));
      }
    } else if (selectedBreaksStart[1] == null &&
        selectedBreaksStart[0] != null) {
      for (int i = 0;
          i < (selectedBreaksStart[0].difference(selectedStart).inHours);
          i++) {
        slots.add(selectedStart.add(Duration(hours: i)));
      }
      for (int i = 0;
          i < (selectedEnd.difference(selectedBreaksEnd[0]).inHours);
          i++) {
        slots.add(selectedBreaksEnd[0].add(Duration(hours: i)));
      }
    } else {
      for (int i = 0;
          i < (selectedEnd.difference(selectedStart).inHours);
          i++) {
        slots.add(selectedStart.add(Duration(hours: i)));
      }
    }

    await slots.forEach((slot) {
      controller.uploadBusinessSlot(widget.businessId, slot);
    });
  }

  void onButtonTap() async {
    controller.toggleUploading();
    await setSlots();
    controller.toggleUploading();
  }

  @override
  Widget build(BuildContext context) {
    //controller = context.watch<DaySlotsController>();

    return SingleChildScrollView(
      child: Column(children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          direction: Axis.horizontal,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              startDropDown(),
              const Text(':תחילת יום עבודה'),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              endDropDown(),
              const Text(':סוף יום עבודה'),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              endBreakDropDown(0),
              const Text('עד '),
              startBreakDropDown(0),
              const Text(': הפסקה ראשונה')
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              endBreakDropDown(1),
              Text('עד '),
              startBreakDropDown(1),
              Text(': הפסקה שנייה')
            ]),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        CommonButton(
          text: 'הגדר',
          onTap: () => onButtonTap(),
        ),
      ]),
    );
  }
}
