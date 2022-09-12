import 'package:Appo/models/Business.dart';
import 'package:Appo/models/authentication.dart';
import 'package:Appo/widgets/curve_painter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:Appo/models/businesses.dart';
import 'package:Appo/widgets/profile_image.dart';

import '../widgets/business_image_picker.dart';

class BusinessProfileScreen extends StatefulWidget {
  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  Business _business;

  void initState() {
    super.initState();

    _business = Provider.of<Authentication>(context, listen: false).currentUser;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: SingleChildScrollView(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
      Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: CustomPaint(
          painter: CurvePainter(),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.17,
              ),
              //image
              BusinessProfileImage(_business),
              SizedBox(height: 10),
              //name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _business.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        letterSpacing: 1.15),
                  ),
                ],
              ),
              //details
              SizedBox(height: 30),
              buildPersonalInfo(),
            ],
          ),
        ),
      ),
    ]))));
  }

  Widget buildPersonalInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ),
              Spacer(),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'פרטים אישיים',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(_business.email, style: TextStyle(fontSize: 18)),
              SizedBox(
                width: 15,
              ),
              Icon(Icons.email_outlined),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(_business.phoneNumber, style: TextStyle(fontSize: 18)),
              SizedBox(
                width: 15,
              ),
              Icon(Icons.phone_outlined),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(_business.address + ", " + _business.city,
                  style: TextStyle(fontSize: 18)),
              SizedBox(
                width: 15,
              ),
              Icon(Icons.home_outlined),
            ],
          ),
        ],
      ),
    );
  }
}
