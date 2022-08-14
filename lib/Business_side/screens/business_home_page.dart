import 'dart:convert';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:Appo/models/colors.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import './business_calendar_screen.dart';
import './business_customers_screen.dart';
import './business_profile_screen.dart';
import 'package:Appo/widgets/drawer.dart';



DateTime get _now => DateTime.now();

class BusinessHomeScreen extends StatefulWidget {
  static const routeName = '/business_home';
  int businessID;

  BusinessHomeScreen(this.businessID);

  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  Widget calendar = BusinessCalendarScreen();
  Widget profile = BusinessProfileScreen();
  Widget customers = BusinessCustomersScreen();
  //List<CalendarEventData> _appointments = [];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // void initState()
  // {
  //   super.initState();
  //   getSlots();
  // }

  // //get slots as json file - map of dates
  // Future<void> getSlots() async 
  // {
  //   final url = 'https://appo-ae26e-default-rtdb.firebaseio.com/businesses/${widget.businessID}/times.json';
  //   try {
  //     http.Response response = await http.get(url);
  //     var jsonData = jsonDecode(response.body) as Map;
    
  //     for(var itemKey in jsonData.keys)
  //   {
  //     DateTime date = DB_Helper.convertDateKeyToDate(itemKey);
  //     if(jsonData[itemKey] != null)
  //     {
  //       addDateApposToCalendar(date, jsonData[itemKey]);
  //     }
  //   }
  //   }
  //   catch(err) {
  //     print(err);
  //     throw err;
  //   }
  // }

  // Future<void> addDateApposToCalendar(DateTime date, Map json) async
  // {
  //   for(var timeKey in json.keys)
  //   {
  //     DateTime time = DB_Helper.convertDateTimeKeyToDateTime(timeKey);
  //     if(json[timeKey] != null)
  //     {
  //       if(json[timeKey]['isBooked'] as bool == true)
  //       {
  //         TimeSlot t = TimeSlot.fromJson(json[timeKey]);
  //         Map user = await DB_Helper.findCustomerById(t.userId);
  //         String name = user['name'];
  //         createEvent(t.startTime, name);
  //       }
  //     }
  //   }
  // }

  Widget bodyFunction() {
    switch(_selectedPageIndex) {
          case 0: return calendar;
            break;
          case 1: return profile;
            break;
          case 2: return customers;
            break;
          default: return calendar;
    }
  }

  
  
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: Scaffold(
        appBar: AppBar(title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Appo', style: TextStyle(fontWeight: FontWeight.bold, color: Palette.kToDark[800], fontSize: 24),),
          Image.asset('assets/images/logo.JPG', width: 50, height: 50,),
          
            ],
          ),
         ),
        
        endDrawer: NavDrawer(),

        body: bodyFunction(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).canvasColor,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem( //calendar
              icon: Icon(Icons.calendar_month, size: 30,),
              label: 'יומן'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business, size: 30,),
              label: 'פרופיל'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people, size: 30,),
              label: 'לקוחות'
            ),
          ],
        ),
    ));
  }
}