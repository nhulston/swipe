import 'package:flutter/material.dart';
import 'package:swipe/services/api_service.dart';
import 'package:swipe/services/article_details_page.dart';
import 'package:swipe/services/article_model.dart';
import 'package:swipe/services/customListFile.dart';

class displayArticle extends StatefulWidget {
  @override
  _displayArticleState createState() => _displayArticleState();
}

class _displayArticleState extends State<displayArticle> {
  ApiService client = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: client.getArticle(),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          //let's check if we got a response or not
          if (snapshot.hasData) {
            //Now let's make a list of articles
            List<Article> articles = (snapshot.data)!;
            return ListView.builder(
              //Now let's create our custom List tile
              itemCount: articles.length,
              itemBuilder: (context, index) =>
                  customListTile(articles[index], context),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
