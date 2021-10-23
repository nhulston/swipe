import 'package:swipe/models/asset_data.dart';

class CryptoData extends AssetData {
  double marketCap;
  double circulatingSupply;
  double maxSupply;

  CryptoData(closePrice, openPrice, highPrice, lowPrice, yearHighPrice,
      yearLowPrice, volume, this.marketCap, this.circulatingSupply, this.maxSupply) : super(closePrice, openPrice, highPrice, lowPrice, yearHighPrice,
      yearLowPrice, volume);
}