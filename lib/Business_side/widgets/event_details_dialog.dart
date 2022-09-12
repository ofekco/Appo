import 'package:Appo/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsDialog extends StatefulWidget {
  final DateTime startTime;
  final Customer client;

  const EventDetailsDialog({Key key, this.startTime, this.client})
      : super(key: key);

  @override
  _EventDetailsDialogState createState() => _EventDetailsDialogState();
}

class _EventDetailsDialogState extends State<EventDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //name
              Text(
                widget.client.name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),

              //phone number
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone,
                  ),
                  Text(
                    '  ${widget.client.phoneNumber}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),

              //date and time
              Text(
                DateFormat.yMMMMEEEEd("he_IL").format(widget.startTime),
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Text(
                '${DateFormat.Hm("he_IL").format(widget.startTime)} - ${DateFormat.Hm("he_IL").format(widget.startTime.add(Duration(hours: 1)))}',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),

              //close button
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'סגור',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),

        //client image
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(45)),
              child: widget.client.image == null
                  ? Image.asset("assets/images/client.jpg")
                  : Image.memory(widget.client.base64image),
            ),
          ),
        ),
      ],
    );
  }
}
