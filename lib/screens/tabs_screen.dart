
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profil_screen.dart';

class TabsScreen extends StatefulWidget {

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {

  List<Map<String, Object>> _pages = [
    {'page': HomeScreen(), 'title': 'Home'},
    {'page': ProfileScreen(), 'title': 'Profile'},    
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Row(
        children: [
          Text('Appo', style: TextStyle(fontWeight: FontWeight.bold),),
          Image.asset('assets/images/logoNoBack.png', width: 150, height: 150,),
            ],
          ),
         ),
        
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).canvasColor,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30,),
              label: ''
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30,),
              label: ''
              ),
          ],
        ),
    );
  }
}