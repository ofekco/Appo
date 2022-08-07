import 'package:Appo/models/authentication.dart';
import 'package:Appo/models/colors.dart';
import 'package:Appo/screens/home_screen.dart';
import 'package:Appo/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {

  void _onTap(BuildContext context, Widget navigationPage)
  {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => navigationPage));
  }

  Widget buildNavItem(Function onTap, String title, Icon icon)
  {
    return ListTile(
            title: Text(title, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w600),),
            trailing: IconButton(
              icon: icon, color: Palette.kToDark[800],
              onPressed: onTap
            ),
            onTap: onTap
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [

          DrawerHeader(
            decoration: BoxDecoration(
              color: Palette.kToDark[500],
            ),
            child: ListTile(
                title: Text("Profile Name", textAlign: TextAlign.right, 
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),),
                trailing: IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.white, size: 40,),
                  onPressed: () {},
                ),
                onTap: () {},
            ),
          ),

          buildNavItem(() =>_onTap(context, TabsScreen()),"בית", Icon(Icons.home)),

          Divider(color: Colors.grey),

          buildNavItem(() =>_onTap(context, TabsScreen()),"תנאי שימוש", Icon(Icons.rule)),

          Divider(color: Colors.grey),

          buildNavItem(() =>_onTap(context, TabsScreen()),"הרשם כעסק", Icon(Icons.business)),

          Divider(color: Colors.grey),


          buildNavItem(() =>_onTap(context, TabsScreen()),"צור קשר", Icon(Icons.chat)),

          Divider(color: Colors.grey),

          buildNavItem(() =>_onTap(context, HomeScreen()),"הגדרות", Icon(Icons.settings)),

          Divider(color: Colors.grey),

          buildNavItem(() { 
            Provider.of<Authentication>(context).logout();
            Navigator.of(context).pop(); 
          },
           "התנתק", Icon(Icons.logout)),
        ],
      ) ,
    );
  }
}