import 'package:flutter_yqf/model/home_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
const HOME_URL = 'https://www.devio.org/io/flutter_app/json/home_page.json';
class HomeDao{
  static Future<HomeModel> fetch() async {
    final reponse = await http.get(HOME_URL);
    if(reponse.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //修复中文乱码
      var result = json.decode(utf8decoder.convert(reponse.bodyBytes));
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Failed to load');
    }
  }
}