//Now let's create the article model
// for that we just need to copy the property from the json structure
// and make a dart object

class NewsArticle {
  final String title;
  final String description;
  final String urlToImage;
  final String url;

  NewsArticle(
      {required this.title,
      required this.description,
      required this.urlToImage,
      required this.url});

  factory NewsArticle.fromJSON(Map<String, dynamic> json) {
    return NewsArticle(
        title: json["title"],
        description: json["description"],
        urlToImage: json["urlToImage"],
        url: json["url"]);
  }
}
