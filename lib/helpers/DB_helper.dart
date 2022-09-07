import 'dart:convert';
import 'package:Appo/booking_calendar/model/booking.dart';
import 'package:Appo/booking_calendar/model/time_slot.dart';
import 'package:Appo/models/Business.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:Appo/models/type.dart';
import '../models/http_exception.dart';
import '../models/consts.dart' as consts;
import 'package:Appo/models/Business.dart';

class DB_Helper {
  static Future<List<Type>> getTypesList() async {
    List<Type> res = [];
    try {
      http.Response response = await http.get(Uri.parse(consts.types_url));
      var jsonData = jsonDecode(response.body);

      for (var item in jsonData) {
        if (item != null) {
          Type type = Type(
            id: item['id'],
            title: item['title'],
            imageUrl: item['imageUrl'],
          );
          res.add(type);
        }
      }
    } catch (err) {
      print(err);
      throw err;
    }

    return res;
  }

  static Future<void> postFavorite(String userId, Business itemToAdd) async {
    try {
      await http
          .patch(
              Uri.parse(
                  'https://appo-ae26e-default-rtdb.firebaseio.com/customers/${userId}/favorites/${itemToAdd.id}.json'),
              body: json.encode({
                //encode gets a map
                'businessId': itemToAdd.id
              }))
          .then((res) {
        if (res.statusCode >= 400) {
          throw HttpException('Could not add favorite business');
        }
      });
    } catch (err) {
      print(err);
      throw err;
    }
  }

  static Future<void> removeFromFavorites(
      String userId, Business itemToRemove) async {
    try {
      final response = await http.delete(Uri.parse(
          'https://appo-ae26e-default-rtdb.firebaseio.com/customers/${userId}/favorites/${itemToRemove.id}.json'));
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product!');
      }
    } catch (err) {
      print(err);
      throw err;
    }
  }

  static Future<List<Business>> getAllBusinesses() async {
    try {
      http.Response response = await http.get(Uri.parse(consts.businesses_url));
      var jsonData = jsonDecode(response.body);

      List<Business> res = [];

      res = jsonData.map<Business>((json) => Business.fromJson(json)).toList();
      return res;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  static Future<List<Booking>> getUserUpComingAppointments(
      String userId) async {
    List<Booking> res = [];

    try {
      final url = Uri.parse(
          'https://appo-ae26e-default-rtdb.firebaseio.com/customers/$userId/appointments.json');
      http.Response response = await http.get(url);
      var jsonData = jsonDecode(response.body) as Map<String, dynamic>;

      //res = jsonData.map<Booking>((json) => Booking.fromJson(json)).toList();
      if (jsonData != null) {
        jsonData.forEach((id, data) {
          res.add(Booking.fromJson(data));
        });
      }
    } catch (err) {
      print(err);
      throw err;
    }

    return res;
  }

  static String _getDateKey(DateTime date) {
    String day = date.day.toString();
    String month = date.month.toString();

    if (day.length < 2) {
      day = '0$day';
    }
    if (month.length < 2) {
      month = '0$month';
    }
    return '$day$month${date.year}';
  }

  static DateTime convertDateKeyToDate(String key) {
    int day = int.parse('${key[0]}${key[1]}');
    int month = int.parse('${key[2]}${key[3]}');
    int year = int.parse(key.substring(4));

    return DateTime(year, month, day);
  }

  static DateTime convertDateTimeKeyToDateTime(String key) {
    int day = int.parse('${key[0]}${key[1]}');
    int month = int.parse('${key[2]}${key[3]}');
    int year = int.parse(key.substring(4, 7));
    int hour = int.parse('${key[8]}${key[8]}');
    int min = int.parse(key.substring(9));

    return DateTime(year, month, day, hour, min);
  }

  static Future<List<TimeSlot>> getTimes(int businessId, DateTime date) async {
    String dateKey = _getDateKey(date);
    List<TimeSlot> res = [];
    try {
      final url = Uri.parse(
          'https://appo-ae26e-default-rtdb.firebaseio.com/businesses/$businessId/times/$dateKey.json');
      http.Response response = await http.get(url);
      var jsonData = jsonDecode(response.body) as Map<String, dynamic>;

      if (jsonData != null) {
        jsonData.forEach((id, data) {
          res.add(TimeSlot.fromJson(data));
        });
      }
    } catch (err) {
      print(err);
      throw err;
    }

    return res;
  }

  //create new booking in DB. return false if the slot is already booked
  static Future<bool> uploadNewBooking(int businessId, String userId,
      DateTime date, DateTime startTime, DateTime endTime) async {
    final dateKey = _getDateKey(date);
    final String dateTimeKey =
        '$dateKey${date.hour.toString()}${date.minute.toString()}';
    final url = Uri.parse(
        'https://appo-ae26e-default-rtdb.firebaseio.com/businesses/$businessId/times/$dateKey/$dateTimeKey.json');

    try {
      //check if the slot is still available
      http.Response response = await http.get(url);
      var jsonData = jsonDecode(response.body);

      if (jsonData['isBooked'] == true) //not available
      {
        return false;
      } else {
        //available
        //add booking to businesses times list
        await http
            .patch(url,
                body: json.encode({
                  'userId': userId,
                  'startTime': startTime.toString(),
                  'endTime': endTime.toString(),
                  'isBooked': true
                }))
            .then((res) {
          if (res.statusCode >= 400) {
            throw HttpException(
                'Could not update booking in businesses table. HTTP status code = ${res.statusCode}');
          }
        });

        //add booking to customers appointment list
        await http
            .patch(
                Uri.parse(
                    'https://appo-ae26e-default-rtdb.firebaseio.com/customers/${userId}/appointments/$dateTimeKey.json'),
                body: json.encode({
                  //encode gets a map
                  'businessId': businessId,
                  'date': date.toString(),
                  'startTime': startTime.toString(),
                  'endTime': endTime.toString()
                }))
            .then((res) {
          if (res.statusCode >= 400) {
            throw HttpException('Could not add booking to user appointments');
          }
        });
      }

      return true;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  //gets from database the favorites businesses. for now - favorites of customer id:0
  static Future<dynamic> getFavorites(String userId) async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://appo-ae26e-default-rtdb.firebaseio.com/customers/${userId}/favorites.json'));
      var jsonData = jsonDecode(response.body);

      return jsonData;
    } catch (err) {
      print(err);
      throw err;
    }
  }

  static Future<Map> findCustomerById(String userId) async {
    try {
      final url = Uri.parse(
          'https://appo-ae26e-default-rtdb.firebaseio.com/customers.json');
      http.Response response = await http.get(url);
      var jsonData = jsonDecode(response.body) as Map;

      for (var item in jsonData.entries) {
        if (item.key == userId) {
          return item.value;
        }
      }

      return null;
    } catch (err) {
      throw err;
    }
  }

  static Future<void> postDateTimeToBusiness(int businessId, DateTime date,
      DateTime startTime, DateTime endTime) async {
    final dateKey = _getDateKey(date);
    final String dateTimeKey =
        '$dateKey${startTime.hour.toString()}${startTime.minute.toString()}';

    //add time to businesses times list
    try {
      final url = Uri.parse(
          'https://appo-ae26e-default-rtdb.firebaseio.com/businesses/$businessId/times/$dateKey/$dateTimeKey.json');
      await http
          .patch(url,
              body: json.encode({
                'userId': null,
                'startTime': startTime.toString(),
                'endTime': endTime.toString(),
                'isBooked': false
              }))
          .then((res) {
        if (res.statusCode >= 400) {
          print(res.body);
          throw Exception(
              'Could not update time ${startTime.toString()} in businesses table. HTTP status code = ${res.statusCode}');
        }
      });
    } catch (err) {
      print(err);
      throw err;
    }
  }

  //This method gets slot and business id and removes the slot from business times in DB
  static Future<void> deleteSlot(int businessId, DateTime slot) async {
    final dateKey = _getDateKey(slot);
    final String dateTimeKey =
        '$dateKey${slot.hour.toString()}${slot.minute.toString()}';

    //add time to businesses times list
    try {
      final url = Uri.parse(
          'https://appo-ae26e-default-rtdb.firebaseio.com/businesses/$businessId/times/$dateKey/$dateTimeKey.json');
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete slot!');
      }
    } catch (err) {
      throw err;
    }
  }

  static Future<void> updateCustomerImage(
      String userID, String imagePath) async {
    //DatabaseReference firebaseDB = await FirebaseDatabase.instance
    //.ref('${consts.DB_url}customers/${userID}');

    final url = Uri.parse('${consts.DB_url}customers/${userID}.json');
    try {
      await http
          .patch(url,
              body: json.encode({
                'imageUrl': imagePath,
              }))
          .then((res) {
        if (res.statusCode >= 400) {
          print(res.body);
          throw Exception('Could not update image');
        }
      });
    } catch (error) {
      throw error;
    }
  }
}
