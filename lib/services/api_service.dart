import 'dart:convert';

import 'article_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<NewsArticle>> getArticle(String companyName) async {
    String endPointUrl =
        "https://newsapi.org/v2/everything?apiKey=61c4a69dd3c34d9aaf4737ff5c309a7f&q=${companyName.split(' ')[0]}";
    print(endPointUrl);
    Response response = await get(Uri.parse(endPointUrl));
    print(response.body);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["articles"];
      return list.map((article) => NewsArticle.fromJSON(article)).toList();
    } else {
      throw Exception("Failed to get news");
    }
  }
}
//apikey: 61c4a69dd3c34d9aaf4737ff5c309a7f
