import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import  'package:flutter_cheez/Utils/TextUtils.dart';

class NetworkUtil {

  static final defauilPicture = "https://xn--90aij3acc4e.xn--p1ai/bitrix/templates/aspro_next/images/no_photo_medium.png";
  static final BASE_URL = "https://xn--90aij3acc4e.xn--p1ai";
  static final API_URL = "/mobileapp/api/";


  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;




  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String function, {Map<String, String> headers, encoding}) {
    return http
        .get(
      BASE_URL+API_URL+function,
      headers: headers,
    )
        .then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":"+
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception( statusCode);
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String function,
      {Map<String, String> headers = const {}, body, encoding}) {
    if(encoding == null)
      encoding = Encoding.getByName("utf-8");
    return http
        .post(BASE_URL+API_URL+function, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";

       // throw new Exception( statusCode);
        return statusCode;
      }
     // print("API Response1: " + res);
      var value =_decoder.convert(res);
      print("API Response2: " + value.toString());
      return value;
    });
  }

}