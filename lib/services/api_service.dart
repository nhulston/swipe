import 'dart:convert';

import 'article_model.dart';
import 'package:http/http.dart';
import 'package:swipe/models/asset.dart';

class ApiService {
  final endPointUrl = "https://newsapi.org/v2/everything?q="
      "&from=2021-10-24&sortBy=popularity&apiKey=61c4a69dd3c34d9aaf4737ff5c309a7f";

  Future<List<Article>> getArticle() async {
    Response res = await get(Uri.parse(endPointUrl));

    //first of all let's check that we got a 200 statu code: this mean that the request was a succes
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      //this line will allow us to get the different articles from the json file and putting them into a list
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } else {
      throw ("Error: can't get the Articles");
    }
  }
}
//apikey: 61c4a69dd3c34d9aaf4737ff5c309a7f
