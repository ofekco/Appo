import 'package:Appo/Business_side/screens/business_home_page.dart';
import 'package:Appo/models/colors.dart';
import 'package:Appo/screens/login_screen.dart';
import 'package:Appo/screens/profile_screen.dart';
import 'package:Appo/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';

class NavDrawer extends StatelessWidget {
  void _onTap(BuildContext context, Widget navigationPage) {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => navigationPage));
  }

  void _onTapBecomeBusiness(BuildContext context) async {
    Navigator.of(context).pushReplacementNamed('/');
    await Provider.of<Authentication>(context, listen: false).logout();
    Provider.of<Authentication>(context, listen: false)
        .setAuthMode(AuthMode.BUSINESS);
    Navigator.of(context).pushNamed(AuthScreen.routeName);
  }

  Widget buildNavItem(Function onTap, String title, Icon icon) {
    return ListTile(
        title: Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: IconButton(
            icon: icon, color: Palette.kToDark[800], onPressed: onTap),
        onTap: onTap);
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
              title: Text(
                Provider.of<Authentication>(context).currentUser.name,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {},
              ),
              onTap: () {},
            ),
          ),
          buildNavItem(
              () => _onTap(context, TabsScreen()), "בית", Icon(Icons.home)),

          Divider(color: Colors.grey),

          buildNavItem(() =>_onTapBecomeBusiness(context),"הרשם כעסק", Icon(Icons.business)),

          Divider(color: Colors.grey),

          buildNavItem(
              () => _onTap(context, TabsScreen()), "צור קשר", Icon(Icons.chat)),

          Divider(color: Colors.grey),

          buildNavItem(() => _onTap(context, TabsScreen()), "הגדרות",
              Icon(Icons.settings)),

          Divider(color: Colors.grey),

          buildNavItem(() {
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Authentication>(context, listen: false).logout();
          }, "התנתק", Icon(Icons.logout)),
        ],
      ),
    );
  }
}
