import 'package:Appo/models/colors.dart';
import 'package:Appo/screens/booking_screen.dart';
import 'package:Appo/widgets/business_details_screen_widgets/google_maps_widget.dart';
import 'package:Appo/widgets/favorite_button.dart';
import 'package:Appo/widgets/business_details_screen_widgets/section_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/business.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/curve_painter.dart';
import '../widgets/drawer.dart';
import 'package:uri/uri.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessDetailsScreen extends StatefulWidget {

  final Business business;
  final String clientId;
  static const routeName = 'business-details';
  static const sectionsNames = const ['ביקורות', 'מיקום', 'אודות' ];
  List<SectionButton> sectionButtonsList;

  BusinessDetailsScreen(this.business, this.clientId);

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
    if(_selectedSection == 0) //reviews
    {
      return Container(); //TO DO 
    }
    else if(_selectedSection == 1) //location
    {
      return GoogleMapsView(widget.business.latitude, widget.business.longitude);
    }
    else if(_selectedSection == 2){ //about
      return aboutSection(); 
    }
    else 
      return Container();
  }

  Widget aboutSection()
  {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),

          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.business.phoneNumber,
                    style: TextStyle(fontSize: 14)),
                  SizedBox(width: 15,),
                  Icon(Icons.phone_outlined),             
                ],
          ),
          SizedBox(height: 10),
          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.business.address + ", " + widget.business.city,
                    style: TextStyle(fontSize: 14)),
                  SizedBox(width: 15,),
                  Icon(Icons.home_outlined),             
            ],
          ),
          SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(widget.business.owner,
          //             style: TextStyle(fontSize: 14)),
          //       SizedBox(width: 15,),
          //       Text(':בעלים',
          //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),               
          //   ],
          // ),
          // SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ראשון - חמישי',
                      style: TextStyle(fontSize: 14, )),
                SizedBox(width: 15,),
                Text(':ימי עבודה',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),         
            ],
          ),
          SizedBox(height: 10),
        ]
      )  
    );
  }

  Future<void> openInstagram() async {
    if (await canLaunch(widget.business.instagramUrl)) {
      await launch(
        widget.business.instagramUrl,
        forceWebView: true,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open Instagram profile';
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewWithoutJavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    )) {
      throw 'Could not launch $url';
    }
  }

  

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      
      endDrawer: NavDrawer(),
      
      body: SingleChildScrollView(
        child: Stack(children: <Widget> [
          Container(
            color: Colors.white, //screen background color
          ),
      
          SingleChildScrollView(child: 
            Column(children: <Widget> [
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
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 1.15),
                      ),
                      //favorite button
                      FavoriteButton(widget.business),
                    ], 
                  ),
      
                  SizedBox(height: 3,),
      
                  //business type
                  Text("${widget.business.serviceType}", style: 
                    TextStyle(color: Colors.grey.shade400, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
      
                  SizedBox(
                    height: 5,
                  ),
      
                  IconButton(
                    icon: Icon(FontAwesomeIcons.instagram),
                    iconSize: 30,
                    
                    onPressed: () async {
                      await openInstagram();
                    },
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
                          return BookingCalendarScreen(widget.business.id, widget.clientId);
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