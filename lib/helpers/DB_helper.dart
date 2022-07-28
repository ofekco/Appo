import 'dart:convert';
import 'package:Appo/models/Business.dart';
import 'package:http/http.dart' as http;
import '../models/Type.dart';
import '../models/http_exception.dart';
import '../models/consts.dart' as consts;

class DB_Helper {
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
      })).then((res) {
        if(res.statusCode >= 400)
        {
          throw HttpException('Could not add favorite business');
        }
      });
    }
    catch(err) {
      print(err);
      throw err;
    }
  }

  static Future<void> removeFromFavorites(Business itemToRemove) async
  {
    try {
        final response = await http.delete('https://appo-ae26e-default-rtdb.firebaseio.com/customers/0/favorites/${itemToRemove.id}.json');
        if(response.statusCode >= 400) {
          throw HttpException('Could not delete product!');
        }
    }
    catch(err) {
      print(err);
      throw err;
    }
  }

  static Future<List<Business>> getAllBusinesses() async 
  {
    try {
      http.Response response =  await http.get(consts.businesses_url);
      var jsonData = jsonDecode(response.body);
    
      List<Business> res = [];

      res = jsonData.map<Business>((json) => Business.fromJson(json)).toList();
      return res;
    }
    catch(err) {
      print(err);
      throw err;
    }
  }

  //gets from database the favorites businesses. for now - favorites of customer id:0
  static Future<dynamic> getFavorites(int userId) async 
  {
    try {
      http.Response response = await http.get(consts.dummy_favorites);
      var jsonData = jsonDecode(response.body);

      return jsonData;
    }
    catch(err) {
      print(err);
      throw err;
    }
  }
}