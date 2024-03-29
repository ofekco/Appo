import 'package:Appo/models/colors.dart';
import 'package:Appo/widgets/slider_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Appo/models/businesses.dart';
import 'package:provider/provider.dart';
import '../helpers/DB_helper.dart';
import '../models/types.dart';

class FiltersScreen extends StatefulWidget {

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  Types types;

  void initState() {
    super.initState();
    types = Provider.of<Types>(context, listen: false);
  }

  Widget allTypesUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Service Types:',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getTypesList(),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  //This method check change the position of the toggle button.
  //if button 'all' is pressed - change the position of all the other buttons.
  void onTogglePressed(int index) 
  {
    if (index == 0) {
      if (types.TypesList[0].isSelected) {
        types.TypesList.forEach((d) {
          d.isSelected = false;
        });
      } else {
        types.TypesList.forEach((d) {
          d.isSelected = true;
        });
      }
    }
    else {
      types.TypesList[index].isSelected =
          !types.TypesList[index].isSelected;
    }
  }
  
  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Distance from city center',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SliderView(
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  } 
  
  //This method builds one toggle button for 1 type.
  Material getTypeItem(int i)
  {
    final type = types.TypesList[i];
    return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0)),
            onTap: () {
              setState(() {
                onTogglePressed(i);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      type.title,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: type.isSelected
                        ? Palette.kToDark[500]
                        : Colors.grey.withOpacity(0.6),
                    onChanged: (bool value) {
                      setState(() {
                        onTogglePressed(i);
                      });
                    },
                    value: type.isSelected,
                  ),
                ],
              ),
            ),
          ),
        );
  }

  //This method builds the list of toggle buttons for service types
  List<Widget> getTypesList() {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < types.TypesList.length; i++) 
    { 
      list.add(getTypeItem(i));
      if (i == 0) 
      {
        list.add(const Divider(height: 1));
      }
    }
    return list;
  }

  void applyFilters()
  {
    //Businesses businessesList = Businesses.instance;
    Provider.of<Businesses>(context, listen: false).UpdateFilteredList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit filters')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  distanceViewUI(),
                  allTypesUI()
                ],
              ),
            ),
          ),

          const Divider(
            height: 1,
          ),

          //Apply button
          Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      applyFilters();
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
}