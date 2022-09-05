import './common_card.dart';
import 'package:flutter/material.dart';

class BookingDialog extends StatelessWidget {
  const BookingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Center(
          child: CommonCard(child: Icon(Icons.calendar_month, color: Colors.blue, size: 256)),
        ),
        SizedBox(height: 16),
        Text("רק עוד רגע", style: TextStyle(fontWeight: FontWeight.bold),),
      ],
    );
  }
}