import 'package:swipe/Models/asset_data.dart';

class StockData extends AssetData {
  double marketCap;
  double peRatio;
  double dividendYield;

  StockData(closePrice, openPrice, highPrice, lowPrice, yearHighPrice,
      yearLowPrice, volume, this.marketCap, this.peRatio, this.dividendYield) : super(closePrice, openPrice, highPrice, lowPrice, yearHighPrice,
      yearLowPrice, volume);
}