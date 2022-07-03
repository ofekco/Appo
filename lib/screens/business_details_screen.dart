import 'package:flutter/material.dart';
import '../models/Business.dart';


class BusinessDetailsScreen extends StatelessWidget {
  final Business business;

  BusinessDetailsScreen(this.business);

  Widget buildSectionTitle(BuildContext context, String text){
    return Container(margin: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            text, 
            style: Theme.of(context).textTheme.bodyText1,)
    );
  }

  Widget buildListContainer(Widget child) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            border: Border.all(color:Colors.grey),
            borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 150,
           width: 300,
          child: child, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${business.name}'),),
      body: SingleChildScrollView(
        child: 
          Container(
            height: 300, 
            width: double.infinity,
            child: Image.network(business.imageUrl, fit: BoxFit.cover),
          ),
          
        ),
      );
    
  }
}
