import 'dart:convert';
import 'package:Appo/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Authentication with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }


  Future<void> signup(String email, String password) async {
      final url =
        Uri.parse('https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAV3px-slgo-jPGEgUJBYJbDaTledtXIj8');
        try {
          final response = await http.post(
          url,
          body: json.encode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ),
        );

        final responseData = json.decode(response.body);
        if(responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
    
  }

  Future<void> login(String email, String password) async {
    final url =
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAV3px-slgo-jPGEgUJBYJbDaTledtXIj8');
      try {
        final response = await http.post(
          url,
          body: json.encode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ),
        );

        final responseData = json.decode(response.body);
        if(responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}