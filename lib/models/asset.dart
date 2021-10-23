import 'package:swipe/Models/price_data.dart';

class Asset {
  String symbol;
  String name;
  PriceData priceData;

  Asset(this.symbol, this.name, this.priceData);
}