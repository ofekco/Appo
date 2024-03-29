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

class _BusinessRegistrationScreen2State
    extends State<BusinessRegistrationScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  String _typeSelected;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('התרחשה שגיאה'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void itemClicked(BuildContext ctx, Type type) {
    _typeSelected = type.Title;
  }

  @override
  Widget build(BuildContext context) {
    final _types = Provider.of<Types>(context);
    final _deviceSize = MediaQuery.of(context).size;
    final _auth = Provider.of<Authentication>(context, listen: false);

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 159, 195, 212),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _types.TypesList.length > 0
                        ? (_types.TypesList.length - 1)
                        : 0,
                    padding: const EdgeInsets.only(top: 8),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 8, bottom: 16),
                          child: BusinessTypeListItem(
                            _types.TypesList[index + 1],
                            () => itemClicked(
                                context, _types.TypesList[index + 1]),
                          ));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: RaisedButton(
                      child: const Text('סיום'),
                      onPressed: () {
                        (_auth.currentUser as Business).serviceType =
                            _typeSelected;
                        _auth.signupAsBusiness();
                        Navigator.of(context)
                            .popAndPushNamed(BusinessHomeScreen.routeName);
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
}
