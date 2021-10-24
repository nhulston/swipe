// import 'package:flutter/material.dart';
// import 'article_model.dart';
// import 'api_service.dart';
// import 'news_article_view.dart';
//
// enum LoadingStatus { completed, searching, empty }
//
// class NewsArticleListViewModel extends ChangeNotifier {
//   var loadingStatus = LoadingStatus.searching;
//
//   List<NewsArticleViewModel> articles = <NewsArticleViewModel>[];
//
//   Future<void> search(String keyword) async {
//     this.loadingStatus = LoadingStatus.searching;
//     notifyListeners();
//     List<NewsArticle> newsArticles = await ApiService().getArticle();
//     this.articles = newsArticles
//         .map((article) => NewsArticleViewModel(article: article))
//         .toList();
//     this.loadingStatus =
//         this.articles.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
//     notifyListeners();
//   }
//
//   Future<void> populateTopHeadlines() async {
//     this.loadingStatus = LoadingStatus.searching;
//     notifyListeners();
//     List<NewsArticle> newsArticles = await ApiService().getArticle();
//     this.articles = newsArticles
//         .map((article) => NewsArticleViewModel(article: article))
//         .toList();
//     this.loadingStatus =
//         this.articles.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
//     notifyListeners();
//   }
// }
