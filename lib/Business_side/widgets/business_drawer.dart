import 'package:Appo/Business_side/screens/business_home_page.dart';
import 'package:Appo/models/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Appo/models/authentication.dart';

class BusinessDrawer extends StatelessWidget {

  void _onTap(BuildContext context, Widget navigationPage)
  {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
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

          buildNavItem(() =>_onTap(context, BusinessHomeScreen()),"בית", Icon(Icons.home)),

          Divider(color: Colors.grey),

          buildNavItem(() =>_onTap(context, BusinessHomeScreen()),"תנאי שימוש", Icon(Icons.rule)),

          Divider(color: Colors.grey),

          buildNavItem(() =>_onTap(context, BusinessHomeScreen()),"צור קשר", Icon(Icons.chat)),

          Divider(color: Colors.grey),

          buildNavItem(() =>_onTap(context, BusinessHomeScreen()),"הגדרות", Icon(Icons.settings)),

          Divider(color: Colors.grey),

          buildNavItem(() { 
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Authentication>(context, listen: false).logout();
          },"התנתק", Icon(Icons.logout)),
        ],
      ) ,
    );
  }
}