import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/Model/apod.dart';

class APODHelper {
  Future<APOD> getAPOD(String date) async {
    String url =
        "https://api.nasa.gov/planetary/apod?api_key=aWPhODExHc5j48m59viPzCysv1jkoaN7ID2dchPw&date=" + date;

    print(url);

    final response = await http.get(
      url,
      headers:
      {
        "Content-Type": "application/json",
        "access-control-allow-origin":"*"
      },
    );

    // var dio = Dio();
    // Response response = await dio.get(url);
    // print(response.data);

    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      print("***************");
      // print(responseJson);
      APOD apod = new APOD.fromJson(responseJson);
      print(apod);

      return apod;
    } else {
//      print(response.body);
      Map<String, dynamic> responseJson = json.decode(response.body);
      throw responseJson;
    }
  }
}
