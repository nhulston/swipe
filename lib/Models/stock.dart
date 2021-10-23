import 'package:swipe/Models/asset.dart';
import 'package:swipe/Models/price_data.dart';

class Stock extends Asset {

  Stock(String symbol, String name, PriceData priceData) : super(symbol, name, priceData);

}