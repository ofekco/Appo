import 'package:flutter/material.dart';

import '../widgets/curve_painter.dart';
import '../widgets/drawer.dart';


class ProfileScreen  extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      endDrawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Container(
            color: Colors.white, //screen background color
          ),
      
          SingleChildScrollView(child: 
            Column(children: <Widget>[
                  Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.white,
                    child: CustomPaint(
                    painter: CurvePainter(),
                      child: Column(
                        children: [
      
                  SizedBox(
                    height: size.height*0.17,
                  ),
      
                  //image
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: CircleAvatar(
                      radius: size.width*0.22,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: size.width*0.2, 
                        //backgroundImage: NetworkImage(),
                        )
                    ),
                  ),
      
                  SizedBox(
                    height: 10,
                  ),
      
                  //user name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children:[
                      Text("", style: 
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.15),
                      ),
                    ], 
                  ),
                ],
              ),
            ),
          )
        ],),),
          
          //back button
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              title: Text(''),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
                ),
              backgroundColor: Colors.transparent, 
              elevation: 0.0, //No shadow
            ),),
          ]
        ),
      )
    );
  }
}
