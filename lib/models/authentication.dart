import 'dart:async';
import 'dart:convert';
import 'package:Appo/models/Business.dart';
import 'package:Appo/models/http_exception.dart';
import 'package:Appo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'customer.dart';

enum AuthMode { CUSTOMER, BUSINESS }

class Authentication with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  User _currentUser;
  AuthMode _authMode;

  bool get isAuth {
    return token != null;
  }

  User get currentUser {
    return _currentUser;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  void set token(String newToken) {
    _token = newToken;
  }

  void set expiryDate(String newExpiryDate) {
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(newExpiryDate),
      ),
    );
  }

  AuthMode get authMode {
    return _authMode;
  }

  void setAuthMode(AuthMode mode) {
    _authMode = mode;
  }

  void _setFirebaseUserAuth(String email, String password) async {
    try {
      var url = Uri.parse(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAV3px-slgo-jPGEgUJBYJbDaTledtXIj8');
      var response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
    } catch (error) {
      throw error;
    }
  }

  void _setAppCustomerAuth(String email, String password, String name,
      String phone, String address, String city) async {
    try {
      var response = await http.patch(
          Uri.parse(
              'https://appo-ae26e-default-rtdb.firebaseio.com/customers/${_userId}.json'),
          body: json.encode({
            'email': email,
            'password': password,
            'name': name,
            'phone number': phone,
            'city': city
          }));

      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password, String name, String phone,
      String address, String city) async {
    await _setFirebaseUserAuth(email, password);
    await _setAppCustomerAuth(email, password, name, phone, address, city);

    _currentUser =
        new Customer(_userId, _token, email, name, address, city, phone, "");
    notifyListeners();
    _autoLogout();
    await storeAuthDataOnDevice();
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAV3px-slgo-jPGEgUJBYJbDaTledtXIj8');
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
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      await _importCustomerDataFromDB(_userId);
      _autoLogout();
      notifyListeners();
      await storeAuthDataOnDevice();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> storeAuthDataOnDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
      'authMode': _authMode.toString()
    });
    prefs.setString('userData', userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    extractedUserData['authMode'] == 'AuthMode.CUSTOMER'
        ? _authMode = AuthMode.CUSTOMER
        : _authMode = AuthMode.BUSINESS;

    _authMode == AuthMode.CUSTOMER
        ? await _importCustomerDataFromDB(_userId)
        : await _importBusinessDataFromDB(_userId);
    notifyListeners();
    _autoLogout();
    return true;
  }

  void _importCustomerDataFromDB(String userId) async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://appo-ae26e-default-rtdb.firebaseio.com/customers/${_userId}.json'));
      var resCust = jsonDecode(response.body);
      _currentUser = new Customer(
        _userId,
        resCust['email'],
        resCust['password'],
        resCust['name'],
        resCust['address'],
        resCust['city'],
        resCust['phone number'],
        resCust['imageUrl'],
      );
    } catch (err) {
      print(err);
      throw err;
    }
  }

  //--------------------------BUSINESS------------------------//

  Future<void> loginAsBusiness(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAV3px-slgo-jPGEgUJBYJbDaTledtXIj8');
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
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      await _importBusinessDataFromDB(_userId);
      _autoLogout();
      notifyListeners();
      await storeAuthDataOnDevice();
    } catch (error) {
      throw error;
    }
  }

  void _importBusinessDataFromDB(String userId) async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://appo-ae26e-default-rtdb.firebaseio.com/businesses/${_userId}.json'));
      var resCust = jsonDecode(response.body);
      _currentUser = Business.fromJson(resCust);
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> signupAsBusiness() async {
    await _setAppBusinessAuth(
        _currentUser.email,
        _currentUser.name,
        _currentUser.phoneNumber,
        _currentUser.address,
        _currentUser.city,
        (_currentUser as Business).serviceType);

    notifyListeners();
    _autoLogout();
    await storeAuthDataOnDevice();
  }

  void createInitialBusiness(String email, String password, String name,
      String phone, String address, String city) async {
    await _setFirebaseUserAuth(email, password);
    _currentUser = new Business(
        userId: _userId,
        email: email,
        password: password,
        name: name,
        phone: phone,
        address: address,
        city: city,
        instagramUrl: "",
        latitude: 32.109333,
        longitude: 34.855499,
        imageUrl: "");
  }

  void _setAppBusinessAuth(String email, String name, String phone,
      String address, String city, String type) async {
    try {
      var response = await http.patch(
          Uri.parse(
              'https://appo-ae26e-default-rtdb.firebaseio.com/businesses/${_userId}.json'),
          body: json.encode({
            'id': _userId,
            'email': email,
            'name': name,
            'phone number': phone,
            'address': address,
            'city': city,
            'type': type,
            'longitude': '34.855499',
            'latitude': '32.109333',
            'instagram': "",
            'imageUrl': "",
          }));

      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }
}
