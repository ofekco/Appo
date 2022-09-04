import 'package:Appo/models/colors.dart';
import 'package:Appo/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/booking.dart';

class BookingConfirmation extends StatelessWidget
{
  Booking booking;

  BookingConfirmation(this.booking);

  @override 
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, 
      color: Colors.white,
      child:Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: <Widget> [
          Container(height: 70,
            child: Column(children: [
              Text('נקבע עבורך תור', style: TextStyle(fontWeight: FontWeight.bold),),
              Text('${booking.date.day}.${booking.date.month} בתאריך', style: TextStyle(fontWeight: FontWeight.bold),),
              Text('${booking.startTime.hour}:${booking.startTime.minute}0 בשעה', style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
              
          Container(
            margin:const EdgeInsets.all(15.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 ElevatedButton( 
                  onPressed: () => Navigator.of(context).pushReplacementNamed(TabsScreen.routeName),
                  child: const Text('הוסף ליומן גוגל', style: TextStyle(fontWeight: FontWeight.w700),),
                  style: ElevatedButton.styleFrom(
                    primary:  Palette.kToDark[50],
                    padding: const EdgeInsets.all(10), 
                    textStyle: TextStyle(
                    color: Colors.white,
                   )),
                  ),


                 ElevatedButton(
                  onPressed:  () => Navigator.of(context).pushReplacementNamed(TabsScreen.routeName),
                  child:const Text('סגור', style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary:  Palette.kToDark[50],
                    padding: const EdgeInsets.all(10), 
                    textStyle: TextStyle(
                    color: Colors.white,
                   )),
                ),
              ])
            )
        ]),
      )
    );
  }
}