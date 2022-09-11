import 'package:Appo/Business_side/model/colors.dart';
import 'package:Appo/Business_side/screens/business_home_page.dart';
import 'package:Appo/models/Business.dart';
import 'package:Appo/models/authentication.dart';
import 'package:Appo/models/types.dart';
import 'package:Appo/models/type.dart';
import 'package:Appo/widgets/business_type_item.dart';
import 'package:Appo/widgets/wrap_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessRegistrationScreen2 extends StatefulWidget {
  static const routeName = '/register_business2';
  @override
  State<BusinessRegistrationScreen2> createState() =>
      _BusinessRegistrationScreen2State();
}

class _BusinessRegistrationScreen2State extends State<BusinessRegistrationScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  String _typeSelected;
  String _typeImageUrl;
  List<bool> isItemClicked = [];

 
  void itemClicked(Type type) {
    _typeSelected = type.Title;
    _typeImageUrl = type.ImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final _types = Provider.of<Types>(context);
    final _deviceSize = MediaQuery.of(context).size;
    final _auth = Provider.of<Authentication>(context, listen: false);
    isItemClicked = List.filled(_types.TypesList.length, false);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 159, 195, 212),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8),
                  scrollDirection: Axis.vertical,
                  children: createList(_types.TypesList), 
              )),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: RaisedButton(
                  child: const Text('סיום'),
                  onPressed: () {
                    (_auth.currentUser as Business).serviceType = _typeSelected;
                    (_auth.currentUser as Business).imageUrl = _typeImageUrl;
                    _auth.signupAsBusiness();
                    Navigator.of(context).popAndPushNamed(BusinessHomeScreen.routeName);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  color: Palette.kToDark[600],
                  textColor: Colors.white),
              ),
            ],
          )
        ],
      ));
  }

  Widget buildInkWell(int index, List<Type> types) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 8, bottom: 16),
      child: InkWell(
      onTap: () {
        itemClicked(types[index]);
        
        setState(() {
          isItemClicked.forEach((clicked) { clicked = false; });
          isItemClicked[index] = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AspectRatio(
                    //business image
                    aspectRatio: 2,
                    child: types[index].imageUrl == null
                      ? Container()
                      : Image.network(
                          types[index].imageUrl,
                          fit: BoxFit.cover,
                        ),
                  ),
                  Container(
                    color: Theme.of(context).canvasColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //type
                                  Text(
                                    types[index].title,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: isItemClicked[index]
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      fontSize: 22,
                                      color: isItemClicked[index]
                                          ? Palette.kToDark[800]
                                          : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
  ));
  }


  List<Widget> createList (List<Type> list) {
    List<Widget> res = [];

    for(int i=1; i<list.length; i++) {
      res.add(buildInkWell(i, list));
    }
  
    return res;
  }
}
