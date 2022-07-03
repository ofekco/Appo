import 'package:flutter/material.dart';
import '../models/Business.dart';
import '../screens/business_details_screen.dart';

class FavoriteItem extends StatelessWidget {
  final Business bis;

  FavoriteItem(this.bis);

  void selectCategory(BuildContext ctx) 
  {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return BusinessDetailsScreen(bis);
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 120, height: 120,
            margin: EdgeInsets.all(5),
            child: Column(children: <Widget> [
              CircleAvatar(backgroundImage: NetworkImage(bis.imageUrl), radius: 40,),
              Text(bis.name, style: Theme.of(context).textTheme.bodyText1),
            ]
      ),
    );
  }
}