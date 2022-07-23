import './Business.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './consts.dart' as consts;
import './database_methods.dart';
import './Type.dart';

//All the businesses from the server
class Businesses {

  List<Business> _businesses;
  List<Business> _filteredList;

  //the class implemented as a singlethon
  Businesses._privateConstructor() {
    _businesses = [];
    _filteredList = [];
  }

  static final Businesses _instance = Businesses._privateConstructor();

  static Businesses get instance => _instance;

  List<Business> get BusinessesList {
    return _businesses;
  }

  List<Business> get FilteredList {
    return _filteredList;
  }

  Business findByID(int id)
  {
    return _businesses.firstWhere((b) => b.id == id);
  }

  Future<void> getData() async 
  {
    http.Response response =  await http.get(consts.businesses_url);
    var jsonData = jsonDecode(response.body);

    _businesses =  jsonData.map<Business>((json) => Business.fromJson(json)).toList();
    _filteredList = _businesses;
    // for(var item in jsonData)
    // {
    //   if(item != null)
    //   {
    //     Business bis = Business(
    //       id: item['id'],
    //       name: item['name'],
    //       owner: item['owner'],
    //       city: item['city'], 
    //       address: item['address'],
    //       phoneNumber: item['phoneNumber'], 
    //       imageUrl: item['imageUrl'],
    //       serviceType: item['serviceType'],
    //     );
    //     _businesses.add(bis);
    //   }
    // }
  }

  //gets from database the favorites businesses. for now - favorites of customer id:0
  Future<List<Business>> getFavorites() async 
  {
    http.Response response = await http.get(consts.dummy_favorites);
    var jsonData = jsonDecode(response.body);

    List<Business> res = [];

    if(jsonData != null)
    {
      if(_businesses.length == 0)
      {
            await getData();
      }
      for(var item in jsonData) 
      {
        if(item != null)
        {
          Business bis = findByID(item['businessId']); //maybe replace with get request to the server to get the business
          res.add(bis);
          bis.isFavorite = true;
        }
      }
      
    }
    return res;
  }

  void UpdateFilteredList()
  {
    List<Business> newFilteredList = [];
    _businesses.forEach((item) 
    {
      Type type = DatabaseMethods.findTypeByTitle(item.serviceType);
      if(type.isSelected)
      {
        newFilteredList.add(item);
      }
    });

    _filteredList = newFilteredList;
  } 
}