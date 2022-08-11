import 'package:Appo/models/colors.dart';
import 'package:flutter/material.dart';
import './business_calendar_screen.dart';
import './business_customers_screen.dart';
import './business_profile_screen.dart';
import 'package:Appo/widgets/drawer.dart';


class BusinessHomeScreen extends StatefulWidget {
  static const routeName = '/business_home';
  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  Widget calendar = BusinessCalendarScreen();
  Widget profile = BusinessProfileScreen();
  Widget customers = BusinessCustomersScreen();

  int _selectedPageIndex = 0;

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
          case 2: return customers;
            break;
          default: return calendar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}