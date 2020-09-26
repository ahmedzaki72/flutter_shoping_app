import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _exiryDate;
  String _userId;
  Timer _autoTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_exiryDate != null &&
        _exiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return _token;
  }

  String get userId {
    return _userId;
  }

  /// i will using one function to using in signIn and using in signUp
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAHumGYx8JEZhKRIzki3tjqjecNBGgW6Uc';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        HttpException(
          throw responseData['error']['message'],
        );
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _exiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      autoLogout ();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _exiryDate.toIso8601String(),
      });
      prefs.setString('userData' , userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> tryAutoLogin () async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = jsonDecode(prefs.getString('userData'),) as Map<String , Object> ;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _exiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signup(String email, String password) async {
    // const url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAHumGYx8JEZhKRIzki3tjqjecNBGgW6Uc';
    // final response = await http.post(
    //   url,
    //   body: json.encode({
    //     'email': email,
    //     'password': password,
    //     'returnSecureToken': true,
    //   }),
    // );
    // print(
    //   jsonDecode(response.body),
    // );
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    // const url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAHumGYx8JEZhKRIzki3tjqjecNBGgW6Uc';
    // final response = await http.post(
    //   url,
    //   body: json.encode({
    //     'email': email,
    //     'password': password,
    //     'returnSecureToken': true,
    //   }),
    // );
    // print(
    //   json.decode(response.body),
    // );
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout () async{
    _token = null;
    _userId = null;
    _exiryDate = null;
    if(_autoTimer != null) {
      _autoTimer.cancel();
      _autoTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void autoLogout () {
    if(_autoTimer != null ) {
      _autoTimer.cancel();
    }
    final timeToExpiry = _exiryDate.difference(DateTime.now()).inSeconds;
    _autoTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
