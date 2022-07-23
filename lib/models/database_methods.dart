import 'dart:convert';
import 'package:Appo/models/Business.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './Type.dart';
import './consts.dart' as consts;

class DatabaseMethods {
  static List<Type> _types = [];

  static List<Type> get TypesList {
    if(_types.length == 0)
    {
      getTypesList();
    }
    return _types;
  }

  static Future<Type> findTypeByTitleAsync(String title) async
  {
    if(_types.length == 0)
    {
      await getTypesList();
    }
    return _types.firstWhere((t) => t.title == title);
  }

  static Type findTypeByTitle(String title)
  {
    return _types.firstWhere((t) => t.title == title);
  }

  static Future<void> getTypesList() async 
  {
    try {
      http.Response response =  await http.get(consts.types_url); 
      var jsonData = jsonDecode(response.body);

      for(var item in jsonData)
      {
        if(item != null)
        {
          Type type = Type(
            id: item['id'],
            title: item['title'],
            imageUrl: item['imageUrl'],
          );
          _types.add(type);
        }
      }
    }
    catch(err) {
      print(err);
      throw err;
    }
  }

  static Future<void> postFavorite(Business itemToAdd) async
  {
    try {
        await http.patch('https://appo-ae26e-default-rtdb.firebaseio.com/customers/0/favorites/${itemToAdd.id}.json', body: json.encode({ //encode gets a map
          'businessId': itemToAdd.id
      }));
    }
    catch(err) {
      print(err);
      throw err;
    }
  }

  static Future<void> removeFromFavorites(Business itemToRemove) async
  {
    try {
        await http.delete('https://appo-ae26e-default-rtdb.firebaseio.com/customers/0/favorites/${itemToRemove.id}.json');
    }
    catch(err) {
      print(err);
      throw err;
    }
  }

 
}