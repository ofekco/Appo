import 'dart:convert';
import 'package:Appo/booking_calendar/model/booking.dart';
import 'package:Appo/booking_calendar/model/time_slot.dart';
import 'package:Appo/models/Business.dart';
import 'package:http/http.dart' as http;
import '../models/Type.dart';
import '../models/http_exception.dart';
import '../models/consts.dart' as consts;
import 'package:intl/intl.dart';

class DB_Helper {
  
  static Future<List<Type>> getTypesList() async 
  {
    List<Type> res = [];
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
          res.add(type);
        }
      }
    }
    catch(err) {
      print(err);
      throw err;
    }

    return res;
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

  static Future<List<Booking>> getUserUpComingAppointments(int userId) async 
  {
    List<Booking> res = [];

    try {
      final url = 'https://appo-ae26e-default-rtdb.firebaseio.com/customers/$userId/appointments.json';
      http.Response response =  await http.get(url);
      var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    
      //res = jsonData.map<Booking>((json) => Booking.fromJson(json)).toList();
      if(jsonData != null)
      {
        jsonData.forEach((id, data) {
          res.add(Booking.fromJson(data));
        });
      }
    }
    catch(err) {
      print(err);
      throw err;
    }

    return res;
  }

  static String _getDateKey(DateTime date)
  {
    String day = date.day.toString();
    String month = date.month.toString();

    if(day.length < 2) {
      day = '0$day'; 
    }
    if(month.length < 2)
    {
      month = '0$month';
    }
    return '$day$month${date.year}';
  }

  static DateTime convertDateKeyToDate(String key)
  {
    int day = int.parse('${key[0]}${key[1]}');
    int month = int.parse('${key[2]}${key[3]}');
    int year = int.parse(key.substring(4));

    return DateTime(year, month, day);
  }

  static DateTime convertDateTimeKeyToDateTime(String key)
  {
    int day = int.parse('${key[0]}${key[1]}');
    int month = int.parse('${key[2]}${key[3]}');
    int year = int.parse(key.substring(4,7));
    int hour = int.parse('${key[8]}${key[8]}');
    int min = int.parse(key.substring(9));

    return DateTime(year, month, day, hour, min);
  }

  static Future<List<TimeSlot>> getTimes(int businessId, DateTime date) async 
  {
    String dateKey = _getDateKey(date);
    List<TimeSlot> res = [];
    try {
      final url = 'https://appo-ae26e-default-rtdb.firebaseio.com/businesses/$businessId/times/$dateKey.json';
      http.Response response = await http.get(url);
      var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      
      if(jsonData != null)
      {
        jsonData.forEach((id, data) {
          res.add(TimeSlot.fromJson(data));
        });
      }
      
    }
    catch(err) {
      print(err);
      throw err;
    }

    return res;
  }

  static Future<void> uploadNewBooking(int businessId, int userId, DateTime date,
     DateTime startTime, DateTime endTime) async
  {
    final dateKey = _getDateKey(date);
    final String dateTimeKey = '$dateKey${date.hour.toString()}${date.minute.toString()}';

    try { //add booking to customers appointment list
        await http.patch('https://appo-ae26e-default-rtdb.firebaseio.com/customers/0/appointments/$dateTimeKey.json', 
        body: json.encode({ //encode gets a map
          'businessId': businessId,
          'date': date.toString(),
          'startTime': startTime.toString(),
          'endTime': endTime.toString()
      })).then((res) {
        if(res.statusCode >= 400)
        {
          throw HttpException('Could not add booking to user appointments');
        }
      });

  
      //add booking to businesses times list
      final url ='https://appo-ae26e-default-rtdb.firebaseio.com/businesses/$businessId/times/$dateKey/$dateTimeKey.json';
      await http.patch(url,
      body: json.encode({
        'userId': userId,
        'startTime': startTime.toString(),
        'endTime': endTime.toString(),
        'isBooked': true
        }
      )).then((res) {
        if(res.statusCode >= 400)
        {
          print(res.body);
          throw HttpException('Could not update booking in businesses table. HTTP status code = ${res.statusCode}');
        }
      });

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

  static Future<Map> findCustomerById(int id) async
  {
    try {
      final url = 'https://appo-ae26e-default-rtdb.firebaseio.com/customers.json';
      http.Response response = await http.get(url);
      var jsonData = jsonDecode(response.body) as Map;

      for(var item in jsonData.entries)
      {
        if(item.value['id'] == id)
        {
          return item.value;
        }
      }

      return null;

    }
    catch(err) {
      throw err;
    }
  }
}