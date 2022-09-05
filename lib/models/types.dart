import 'package:Appo/helpers/DB_helper.dart';
import 'package:flutter/material.dart';

import './type.dart';

class Types with ChangeNotifier
{
  static List<Type> _types = [];

  List<Type> get TypesList {
    if(_types.length == 0)
    {
      getTypes();
    }
    return _types;
  }

  Future<void> getTypes() async {
    _types = await DB_Helper.getTypesList();
    notifyListeners();
  }

  static Type findTypeByTitle(String title)
  {
    return _types.firstWhere((t) => t.title == title, orElse: () => null,);
  }
}