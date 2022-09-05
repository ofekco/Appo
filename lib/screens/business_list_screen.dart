import 'package:Appo/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:Appo/models/colors.dart';
import 'package:Appo/widgets/businesses_list.dart';
import 'package:Appo/widgets/searchBar.dart';
import '../widgets/businesses_list.dart';
import '../widgets/searchBar.dart';
import './filters_screen.dart';

//search screen
class BusinessListScreen extends StatelessWidget {
  
  Widget getFilterBar(BuildContext context)
  {
    return Material(
      color: Colors.transparent,
      child: InkWell( //filters button
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.grey.withOpacity(0.2),
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.push<dynamic>(context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => FiltersScreen(),
                fullscreenDialog: true),
              );
            },
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: <Widget>[
              Text('Filter', style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16,),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.sort, color: Palette.kToDark[500]),
              ),
            ],
          ),
        ),
      )
    );        
  }

  @override
  Widget build(BuildContext context) {
    
    AppBar appBar = AppBar(
      title: Text(''),
      leading: new IconButton(
      icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
        ),
      backgroundColor: Colors.transparent, 
      elevation: 0.0, //No shadow
    );

    double appBarHeight = appBar.preferredSize.height;
    double height = MediaQuery.of(context).size.height - appBarHeight;

    return Scaffold(

      //appBar: AppBar(title: Text('search'),),

      endDrawer: NavDrawer(),

      body: Stack(children:[ 
        Column(children: [
          SizedBox(height: appBarHeight),

          Container(
            height: height/9, 
            child: SearchBar(null)),

          getFilterBar(context),

          Expanded(child: BusinessesList()),

        ]),

        //back button
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: appBar
        ),
      ],),
    ); 
  }
}