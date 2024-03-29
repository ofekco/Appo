import 'package:Appo/helpers/DB_helper.dart';
import 'package:flutter/material.dart';
import '../booking_calendar/model/booking.dart';
import '../models/Business.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/types.dart';

class MyNextItem extends StatelessWidget {
  final Booking appointment;
  final Business bis;

  MyNextItem(this.appointment, this.bis);

  Widget buildConstrainedBox(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    Types types = Provider.of<Types>(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: 180, maxHeight: 200, minWidth: 200, maxWidth: 280),
      child: Stack(
        children: [
          //background container
          Container(
            width: width,
            height: height,
            padding: EdgeInsets.only(
                top: height / 8, left: 20, right: 20, bottom: 20),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).cardColor.withOpacity(1),
                    Theme.of(context).cardColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0.0, 0.75),
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ]),
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              //Text
              child: Column(
                children: [
                  Text(bis.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16)), //business name

                  Text(
                      '${DateFormat.Hm("he_IL").format(appointment.startTime)} | ${DateFormat.MMMEd("he_IL").format(appointment.startTime)}',
                      style:
                          TextStyle(fontSize: 14)), //appointment date and time

                  Text('${bis.address} | ${bis.city}',
                      style: TextStyle(fontSize: 12)), //business address
                ],
              ),
            ),
          ),

          //Top image container (type image)

          Consumer<Types>(
              builder: ((_, types, __) =>
                  Types.findTypeByTitle(bis.serviceType) == null
                      ? Container()
                      : Container(
                          width: width,
                          height: height / 8,
                          padding: const EdgeInsets.only(
                              top: 65, left: 20, right: 20, bottom: 20),
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      Types.findTypeByTitle(bis.serviceType)
                                          .imageUrl),
                                  fit: BoxFit.cover))))),
          // circular logo
          Center(
              child: Container(
            margin: EdgeInsets.only(bottom: 60),
            child: CircleAvatar(
                radius: 37,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundImage: MemoryImage(bis.base64image),
                  radius: 35,
                  backgroundColor: Colors.black,
                )),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildConstrainedBox(context);
  }
}
