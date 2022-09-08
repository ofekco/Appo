import 'dart:convert';
import 'package:Appo/Business_side/screens/add_edit_slots_screen.dart';
import 'package:Appo/helpers/DB_helper.dart';
import 'package:Appo/models/authentication.dart';
import 'package:Appo/models/colors.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import './business_calendar_screen.dart';
import './business_profile_screen.dart';
import 'package:Appo/widgets/drawer.dart';
import '../widgets/business_drawer.dart';


DateTime get _now => DateTime.now();

class BusinessHomeScreen extends StatefulWidget {
  static const routeName = '/business_home';

  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  Widget calendar = BusinessCalendarScreen();
  Widget profile = BusinessProfileScreen();
  String businessID;
  int _selectedPageIndex = 0;
  
  @override
  void initState()
  {
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget bodyFunction() {
    switch(_selectedPageIndex) {
          case 0: return calendar;
            break;
          case 1: return profile;
            break;
          default: return calendar;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: Scaffold(

        floatingActionButton: _selectedPageIndex == 0 ? FloatingActionButton(
          backgroundColor: Palette.kToDark[600],
          mini: true,
          foregroundColor: Colors.white,
          child: Icon(Icons.edit),
          tooltip: 'הגדר זמני עבודה נוספים',
          onPressed: () { 
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) 
              {
                businessID = Provider.of<Authentication>(context, listen: false).currentUser.userId;
                return AddOrEditSlotsScreen(businessID);
              })
            );
          }
        ) : null,

        appBar: AppBar(title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Appo', style: TextStyle(fontWeight: FontWeight.bold, color: Palette.kToDark[800], fontSize: 24),),
          Image.asset('assets/images/logo.JPG', width: 50, height: 50,),
            ],
          ),
         ),
        
        endDrawer: BusinessDrawer(),

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
              icon: Icon(Icons.person, size: 30,),
              label: 'פרופיל'
            ),
          ],
        ),
    ));
  }
}