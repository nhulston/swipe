import 'dart:convert';

import 'article_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<NewsArticle>> getArticle() async {
    String endPointUrl =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=61c4a69dd3c34d9aaf4737ff5c309a7f";

    Response response = await get(Uri.parse(endPointUrl));

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
