import 'package:swipe/models/price_data.dart';
import 'package:yahoofin/yahoofin.dart';

import 'asset_data.dart';

abstract class Asset {
  String symbol;
  String name;
  AssetData data;
  ChartQuotes priceData;

  Asset(this.symbol, this.name, this.data, this.priceData);
}