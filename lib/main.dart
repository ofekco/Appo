import 'package:flutter/material.dart';
import 'screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: const Color.fromRGBO(227, 49, 115, 1),
        canvasColor: Colors.white,
        cardColor: const Color.fromRGBO(249, 172, 200, 1),
        focusColor: const Color.fromRGBO(237, 125, 166, 1),
      ),
      home: TabsScreen(),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (c) => TabsScreen(),
        );
      },
    );
  }
}
