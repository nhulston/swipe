import 'dart:developer';
// ignore: import_of_legacy_library_into_null_safe
import 'package:finance_quote/finance_quote.dart';

class StockServices {
  fetchStockData() async {
    Map<String, Map<String, dynamic>> quoteRaw = await FinanceQuote.getRawData(quoteProvider: QuoteProvider.yahoo, symbols: <String>['AAPL']);
    for (String key in quoteRaw.keys) {
      log('key: ${quoteRaw[key]}');
    }
  }
}