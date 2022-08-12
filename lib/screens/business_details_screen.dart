import 'package:Appo/models/colors.dart';
import 'package:Appo/screens/booking_screen.dart';
import 'package:Appo/widgets/business_details_screen_widgets/google_maps_widget.dart';
import 'package:Appo/widgets/favorite_button.dart';
import 'package:Appo/widgets/business_details_screen_widgets/section_button.dart';
import 'package:flutter/material.dart';
import '../models/Business.dart';
import '../widgets/curve_painter.dart';
import '../widgets/drawer.dart';

class BusinessDetailsScreen extends StatefulWidget {

  final Business business;
  static const routeName = 'business-details';
  static const sectionsNames = const ['ביקורות', 'מיקום', 'לוח זמנים' ];
  List<SectionButton> sectionButtonsList;

  BusinessDetailsScreen(this.business);

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  int _selectedSection = 0;

  void initState()
  {
    super.initState();
    buildSectionButtons();
  }

  void sectionButtonPreesed(int index)
  {
    setState(() 
    {
      for(int i=0; i< widget.sectionButtonsList.length; i++) //set all buttons to unPressed color
      {
        widget.sectionButtonsList[i].state.IsPressed = false;
      }
      _selectedSection = index;
      widget.sectionButtonsList[index].state.IsPressed = true; //set the pressed button to pressed color
    });
  }

  List<Widget> buildSectionButtons()
  {
    widget.sectionButtonsList = [];
    for(int i=0; i<3; i++)
    {
      widget.sectionButtonsList.add(
        SectionButton(
          key: UniqueKey(), 
          title: BusinessDetailsScreen.sectionsNames[i], 
          onPressed: ()=> sectionButtonPreesed(i),
        ),
      );
    }
    return widget.sectionButtonsList;
  }

  Widget showSelectedSection()
  {
    if(_selectedSection == 0) //Sceduale
    {
      return Container();
    }
    else if(_selectedSection == 1)
    {
      return GoogleMapsView(widget.business.latitude, widget.business.longitude);
    }
    else if(_selectedSection == 2){ //reviews
      return Container();
    }
  }

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
                        backgroundImage: NetworkImage(widget.business.imageUrl),
                        )
                    ),
                  ),
      
                  SizedBox(
                    height: 10,
                  ),
      
                  //business name + favorite button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children:[
      
                      //business name
                      Text("${widget.business.name}", style: 
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.15),
                      ),
                      //favorite button
                      FavoriteButton(widget.business),
                    ], 
                  ),
      
                  SizedBox(height: 5,),
      
                  //business type
                  Text("${widget.business.serviceType}", style: TextStyle(color: Colors.grey.shade400),
                  ),
      
                  SizedBox(
                    height: 3,
                  ),
      
                  Text( //business address 
                    "${widget.business.address}, ${widget.business.city}",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
      
                  SizedBox(
                    height: 15,
                  ),
      
                  ElevatedButton( //make an appoitment button
                    clipBehavior: Clip.antiAlias,
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Palette.kToDark[500]),
                      
                    child: const Text('קבע תור'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                          return BookingCalendarScreen(widget.business.id);
                          })
                        );
                    },
                  ),
      
                  SizedBox(
                    height: 20,
                  ),
                  
      
                  Row( //buttons row
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: widget.sectionButtonsList),
      
                  Divider(height: 5, ),
      
                  Expanded(child: showSelectedSection()),
      
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