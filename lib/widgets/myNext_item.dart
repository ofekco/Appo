import 'package:flutter/material.dart';
import '../models/Business.dart';
import '../screens/business_details_screen.dart';

class MyNextItem extends StatelessWidget {
  final Business bis;

  MyNextItem(this.bis);

  void selectCategory(BuildContext ctx) 
  {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return BusinessDetailsScreen(bis);
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 200, height: 180, 
      child: Stack(
        children: [
          Container(width: 200, height: 140,
            padding: const EdgeInsets.only(top: 65, left: 20, right: 20, bottom: 20), margin: EdgeInsets.all(15),
            child: Text(bis.name, style: Theme.of(context).textTheme.bodyText1),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [
              Theme.of(context).cardColor.withOpacity(0.7), 
              Theme.of(context).cardColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          
          Positioned(left: 60, child: CircleAvatar(backgroundImage: NetworkImage(bis.imageUrl), radius: 40,)),
      ],),
    );
  }
}