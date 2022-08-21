import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../misc/app_constants.dart';
import '../models/place_model.dart';

class ApiServices {
  String baseUrl = kEndPointUrl;

  Future<List<PlaceModel>> getInfo() async {
    var apiUrl = '/places';
    http.Response res = await http.get(Uri.parse(baseUrl + apiUrl));
    try {
      if (res.statusCode == 200) {
        List<dynamic> list = json.decode(res.body);
        return list.map((e) => PlaceModel.fromJson(e)).toList();
      } else {
        return <PlaceModel>[];
      }
    } catch (e) {
      debugPrint(e.toString());
      return <PlaceModel>[];
    }
  }
}
