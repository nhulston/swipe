import 'dart:developer';
import 'dart:math';

import 'package:swipe/models/asset_data.dart';
import 'package:swipe/models/stock.dart';
import 'package:swipe/models/stock_data.dart';
import 'package:swipe/utils/randomizer.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:yahoofin/yahoofin.dart';

class StockServices {
  static Future<String> getRandomSymbol() async {
    List<dynamic> symbols = (await parseJsonFromAssets('assets/stocks.json'))["symbols"];
    String symbol = symbols[Random().nextInt(symbols.length)];
    return symbol;
  }
  static Future<Stock> fetchStock(String symbol) async {
    ChartQuotes? quotes = await getChartData(symbol, StockRange.oneDay);
    AssetData assetData = await fetchAssetData(symbol);
    String name = await fetchAssetName(symbol);

    return Stock(symbol, name, assetData, quotes!);
  }

  static Future<String> fetchAssetName(String symbol) async {
    final yfin = YahooFin();
    StockMeta meta = await yfin.getMetaData(symbol);
    return meta.shortName!;
  }


  static Future<AssetData> fetchAssetData(String symbol) async {
    final yfin = YahooFin();
    StockInfo info = yfin.getStockInfo(ticker: symbol);
    StockQuote priceQuote = await yfin.getPrice(stockInfo: info);
    StockQuote changeQuote = await yfin.getPriceChange(stockInfo: info);
    StockQuote volumeQuote = await yfin.getVolume(stockInfo: info);

    double closePrice = priceQuote.currentPrice!;
    double openPrice = closePrice - changeQuote.regularMarketChange!;
    double highPrice = priceQuote.dayHigh!;
    double lowPrice = priceQuote.dayLow!;
    double yearHighPrice = closePrice - changeQuote.fiftyTwoWeekHighChange!;
    double yearLowPrice = closePrice - changeQuote.fiftyTwoWeekLowChange!;
    int volume = volumeQuote.regularMarketVolume!;
    return AssetData(closePrice, openPrice, highPrice, lowPrice, yearHighPrice, yearLowPrice, volume);
  }

  static Future<ChartQuotes?> getChartData(String symbol, StockRange chartRange) async {
    StockInterval interval;
    switch (chartRange) {
      case StockRange.oneDay:
        interval = StockInterval.fiveMinute;
        break;
      case StockRange.fiveDay:
        interval = StockInterval.ninetyMinute;
        break;
      case StockRange.oneMonth:
        interval = StockInterval.oneDay;
        break;
      case StockRange.threeMonth:
        interval = StockInterval.oneDay;
        break;
      case StockRange.oneYear:
        interval = StockInterval.fiveDay;
        break;
      case StockRange.ytd:
        interval = StockInterval.fiveDay;
        break;
      case StockRange.fiveYear:
        interval = StockInterval.oneMonth;
        break;
      default:
        interval = StockInterval.oneMonth;
    }
    final yfin = YahooFin();
    StockHistory hist = yfin.initStockHistory(ticker: symbol);
    StockChart quotes = await yfin.getChartQuotes(stockHistory: hist, interval: interval, period: chartRange);
    return quotes.chartQuotes;

  }
}