import 'package:flutter/cupertino.dart';
import './Business.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './consts.dart' as consts;
import '../helpers/DB_helper.dart';
import './Type.dart';

//All the businesses data from the server
class Businesses with ChangeNotifier{

  List<Business> _businesses;
  List<Business> _filteredList;
  List<Business> _favorites;

  Businesses() {
    _businesses = [];
    _filteredList = [];
    _favorites = [];
  }

  //static final Businesses _instance = Businesses._privateConstructor();

  //static Businesses get instance => _instance;

  List<Business> get BusinessesList {
    return _businesses;
  }

  List<Business> get FilteredList {
    return _filteredList;
  }

  List<Business> get Favorites {
    return _favorites;
  }

  Business findByID(int id)
  {
    return _businesses.firstWhere((b) => b.id == id);
  }

  //gets the businessesList from the server and stored it to Businesses list
  Future<void> getAllBusinesses() async 
  {
    _businesses = await DB_Helper.getAllBusinesses();
    _filteredList = _businesses;
    
    notifyListeners();
  }

  //gets from database the favorites businesses. for now - favorites of customer id:0
  Future<List<Business>> getFavorites() async 
  {
    var jsonData = await DB_Helper.getFavorites(0); //returns json

    List<Business> favoritesList = [];

    if(jsonData != null)
    {
      if(_businesses.length == 0)
      {
        await DB_Helper.getAllBusinesses();
      }
      for(var item in jsonData) 
      {
        if(item != null)
        {
          Business bis = findByID(item['businessId']); //maybe replace with get request to the server to get the business
          favoritesList.add(bis);
          bis.isFavorite = true;
        }
      }
      
    }
    _favorites = favoritesList;
    notifyListeners();
    return favoritesList;
  }

  void UpdateFilteredList()
  {
    List<Business> newFilteredList = [];
    _businesses.forEach((item) 
    {
      Type type = DB_Helper.findTypeByTitle(item.serviceType);
      if(type.isSelected)
      {
        newFilteredList.add(item);
      }
    });

    _filteredList = newFilteredList;
    notifyListeners();
  } 
}