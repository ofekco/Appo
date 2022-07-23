import 'package:Appo/models/colors.dart';
import 'package:Appo/widgets/favorite_button.dart';
import 'package:Appo/widgets/section_button.dart';
import 'package:flutter/material.dart';
import '../models/Business.dart';

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

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: <Widget>[
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
                  onPressed: () {},
                ),

                SizedBox(
                  height: 20,
                ),
                

                Row( //buttons row
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.sectionButtonsList),

                Divider(height: 5, )

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
      )
    );
  }
}


class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.shader = LinearGradient(
            colors: [Palette.kToDark[500], Palette.kToDark[50], Palette.kToDark[50]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)
        .createShader(
      Rect.fromLTRB(
        size.width * 0.15,
        size.height * 0.15,
        size.width,
        size.height * 0.1,
      ),
    );
    var path = Path();
    path.moveTo(0, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0.48, size.height * 0.38, size.width, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.38, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}