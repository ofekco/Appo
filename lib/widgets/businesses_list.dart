import 'package:Appo/widgets/wrap_inkwell.dart';
import 'package:flutter/material.dart';
import '../models/Business.dart';
import '../models/businesses.dart';
import '../screens/business_details_screen.dart';
import './business_list_item.dart';
import 'package:provider/provider.dart'; 

class BusinessesList extends StatefulWidget {

  BusinessesList();

  @override
  State<BusinessesList> createState() => _BusinessesListState();
}

class _BusinessesListState extends State<BusinessesList> {

  void itemClicked(BuildContext ctx, Business bis) 
  {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_) {
      return BusinessDetailsScreen(bis, Provider.of<Businesses>(context, listen: false).ClientId);
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    final _businesses = Provider.of<Businesses>(context); //we want to listen to changes in businesses list
    if(_businesses.BusinessesList == null)
    {
          return Container(child: const Center(child: Text('Loading...')));
    }
    else {
      return ListView.builder(
            itemCount: _businesses.FilteredList.length, 
            padding: const EdgeInsets.only(top: 8),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return Padding( 
                      padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 16),
                      child: WrapInkWell(BusinessListItem(_businesses.FilteredList[index]), () => itemClicked(context, _businesses.FilteredList[index]))
                );                 
              },
            );
          }   
      }
  }
