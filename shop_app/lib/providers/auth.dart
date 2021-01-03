import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAutheticated {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) {
    return _authenticate("signUp", email, password);
  }

  Future<void> signIn(String email, String password) {
    return _authenticate("signInWithPassword", email, password);
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("userData")) {
      return false;
    }

    final extractedUserData =
        json.decode(preferences.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> _authenticate(
    String method,
    String email,
    String password,
  ) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$method?key=AIzaSyC_J4-spDnoYc9eheYTm1MZdLaZmiLMJdQ";

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

      final decodedData = json.decode(response.body);

      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }

      _token = decodedData['idToken'];
      _userId = decodedData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            decodedData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();

      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      preferences.setString('userData', userData);
    } catch (e) {
      throw e;
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

    final preferences = await SharedPreferences.getInstance();
    preferences.remove("userData");
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () {
      logout();
    });
  }
}
