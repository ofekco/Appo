import 'package:Appo/models/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../booking_calendar/model/booking.dart';
import 'package:http/http.dart' as http;
import '../helpers/DB_helper.dart';
import 'package:Appo/models/type.dart';
import 'package:Appo/models/types.dart';
import 'package:Appo/models/Business.dart';

//All the businesses data from the server
class Businesses with ChangeNotifier {
  String _clientId;
  List<Business> _businesses;
  List<Business> _filteredList;
  List<Business> _favorites;
  List<Booking> _myBookings;

  Businesses() {
    _businesses = [];
    _filteredList = [];
    _favorites = [];
    _myBookings = [];
  }

  String get ClientId {
    return _clientId;
  }

  void set ClientId(value) {
    _clientId = value;
  }

  List<Business> get BusinessesList {
    return _businesses;
  }

  List<Business> get FilteredList {
    return _filteredList;
  }

  List<Business> get Favorites {
    return _favorites;
  }

  List<Booking> get MyBookings {
    return _myBookings;
  }

  void addFavorite(Business business) {
    _favorites.add(business);
    notifyListeners();
  }

  void removeFavorite(Business businessToRemove) {
    _favorites.remove(businessToRemove);
    notifyListeners();
  }

  Business findByID(String id) {
    return _businesses.firstWhere((b) => b.userId == id, orElse: () => null);
  }

  //gets the businessesList from the server and stored it to Businesses list
  Future<void> getAllBusinesses() async {
    _businesses = await DB_Helper.getAllBusinesses();
    _filteredList = _businesses;

    notifyListeners();
  }

  //gets from database the favorites businesses. for now - favorites of customer
  Future<List<Business>> getFavorites() async {
    //var jsonData = await DB_Helper.getFavorites(_clientId); //returns json
    Map<String, dynamic> jsonData = await DB_Helper.getFavorites(_clientId);
    List<dynamic> data = jsonData.values.toList();
    List<Business> favoritesList = [];

    if (jsonData != null) {
      if (_businesses.length == 0) {
        await DB_Helper.getAllBusinesses();
      }
      for (var item in data) {
        if (item != null) {
          Business bis = findByID(item[
              'businessId']); //maybe replace with get request to the server to get the business
          bis.isFavorite = true;
          favoritesList.add(bis);
        }
      }
    }
    _favorites = favoritesList;
    notifyListeners();
    return favoritesList;
  }

  //gets from DB the upcoming appointments of the specific user id

  Future<void> getMyUpComingBookings() async {
    _myBookings = await DB_Helper.getUserUpComingAppointments(_clientId);
    notifyListeners();
  }

  void UpdateFilteredList() {
    List<Business> newFilteredList = [];
    _businesses.forEach((item) {
      Type type = Types.findTypeByTitle(item.serviceType);
      if (type.isSelected) {
        newFilteredList.add(item);
      }
    });

    _filteredList = newFilteredList;
    notifyListeners();
  }
}
