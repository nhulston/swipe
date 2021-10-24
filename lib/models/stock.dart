import 'package:swipe/models/asset.dart';
import 'package:swipe/models/asset_data.dart';
import 'package:swipe/models/news_data.dart';
import 'package:swipe/models/price_data.dart';
import 'package:swipe/models/stock_data.dart';
import 'package:yahoofin/yahoofin.dart';

class Stock extends Asset {

  Stock(String symbol, String name, AssetData stockData, ChartQuotes priceData, NewsData newsData) : super(symbol, name, stockData, priceData, newsData);

}