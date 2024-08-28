import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/constants/app_constants.dart';

class AccessController {
  static final AccessController instance = AccessController._();
  AccessController._();

  late SharedPreferences _sharedPreferences;

  Future<bool> hasValidToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String? token = _sharedPreferences.getString('token');
    if(token != null && !JwtDecoder.isExpired(token)){
      return true;
    }

    return false;
  }

  Future<bool> login(String username, String password) async {
    http.Response response = await http.post(Uri.parse('${appConstants['baseApiUrl']}/auth/login'), 
    headers: <String, String> {
      'Content-Type' : 'application/json'
    },
    body: jsonEncode({
      'username' : username,
      'password' : password,
      'expiresInMins' : 60, //Optional, default = 60
    }));

    if(response.statusCode == 200){
      String token = jsonDecode(response.body)['token'];
      int userId = jsonDecode(response.body)['id'];

      _sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences.setString('token', token);
      _sharedPreferences.setInt('userId', userId);

      //JWT Decoder example use
      testJwtToken();

      return true;
    }

    return false;
  }

  Future<bool> logout() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
    return true;
  }

  void testJwtToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String? token = _sharedPreferences.getString('token');
    //JWT Decoder test
    if(token != null){
      DateTime expirationDate = JwtDecoder.getExpirationDate(token);
      Duration remainingTime = JwtDecoder.getRemainingTime(token);
      bool isExpired = JwtDecoder.isExpired(token);

      print("Expiration date: "+ expirationDate.toString());
      print("Remaining time: "+ remainingTime.toString());
      print("Is expired: "+ isExpired.toString());

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      print(decodedToken);
    }
  }

  Future<void> refreshToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String? token = await _sharedPreferences.getString('token');

    http.Response response = await http.post(Uri.parse('${appConstants['baseApiUrl']}/auth/refresh'), 
    headers: <String, String> {
      'Content-Type' : 'application/json'
    },
    body: jsonEncode({
      'refreshToken' : token,
      'expireInMins' : 60, //Optional, default = 60
    }));

    if(response.statusCode == 200){
      String newToken = json.decode(response.body)['token'];

      _sharedPreferences.remove('token');
      _sharedPreferences.setString('token', newToken);
      testJwtToken();
    }else {
      print('Failed to refresh token');
    }
  }
}