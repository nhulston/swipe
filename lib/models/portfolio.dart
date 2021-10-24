import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:swipe/card.dart';
import 'package:swipe/models/stock.dart';
import 'package:swipe/services/stocks.dart';
import 'dart:math' as math;
import 'package:swipe/style/app_colors.dart';
import 'package:intl/intl.dart';

class Portfolio {
  static List<String> portfolio = [];
  static List<Widget> items = [];

  static Widget buildItem(BuildContext context, String name, String ticker, String price, double priceChange) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () async {
        try {
          Stock s = await StockServices.fetchStock(ticker);
          AssetCard card = AssetCard(asset: s);
          OneContext().push(
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color(0xff0f0f0f),
                    elevation: 0,
                  ),
                  backgroundColor: const Color(0xff0f0f0f),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: card,
                  ),
                );
              },
            ),
          );
        } catch (exception) {
          Stock s = await StockServices.fetchStock(ticker + "-USD");
          AssetCard card = AssetCard(asset: s);
          OneContext().push(
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color(0xff0f0f0f),
                    elevation: 0,
                  ),
                  backgroundColor: const Color(0xff0f0f0f),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: card,
                  ),
                );
              },
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.almostWhite,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const SizedBox(width: 5),
              const Icon(
                Icons.remove_red_eye,
                color: AppColors.blackText,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: screenWidth / 2.6,
                child: Text(
                  name + " " + "($ticker)",
                  style: TextStyle(
                    fontSize: screenHeight / 50,
                    color: AppColors.blackText,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                price,
                style: TextStyle(
                  fontSize: screenHeight / 60,
                  color: AppColors.blackText,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                formatChange(priceChange),
                style: TextStyle(
                  fontSize: screenHeight / 60,
                  color: priceChange < 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns true if successful, false otherwise
  static Future<bool> addToPortfolio(BuildContext context, String ticker) async {
    double screenHeight = MediaQuery.of(context).size.height;
    ticker = ticker.toUpperCase();
    if (portfolio.contains(ticker)) return true; // Returns true, we just want to return false if invalid ticker

    try {
      Stock stock = await StockServices.fetchStock(ticker);
      String name = removeDashUSD(stock.name);
      String newTicker = removeDashUSD(ticker);
      String price = formatPrice(stock.data.closePrice);
      double change = (((stock.data.closePrice - stock.priceData.close![0]) / stock.priceData.close![0]) * 10000).round().toDouble() / 100;

      print('adding $ticker to portfolio');
      portfolio.add(ticker);
      items.add(buildItem(context, name, newTicker, price, change));
      items.add(SizedBox(height: screenHeight / 100));
      return true;
    } catch(error) {
      throw(error);
      return false;
    }
  }

  static String removeDashUSD(String s) {
    int index = s.indexOf("-USD");
    int index2 = s.indexOf(" USD");
    int index3 = s.indexOf(" Inc.");
    int index4 = s.indexOf(", Inc.");
    if (index == -1 && index2 == -1 && index3 == -1 && index4 == -1) return s;
    int max = math.max(index, index2);
    max = math.max(max, index3);
    max = math.max(max, index4);
    return s.substring(0, max);
  }

  static String formatPrice(double price) {
    final format = NumberFormat("#,##0.00", "en_US");
    return '\$' + format.format(price);
  }

  static String formatChange(double change) {
    final format = NumberFormat("#,##0.00", "en_US");
    return (change < 0 ? '' : '+') + format.format(change) + "%";
  }
}