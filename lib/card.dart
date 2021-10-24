// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_const

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:swipe/graph_card.dart';
import 'package:swipe/services/stocks.dart';
import 'package:swipe/style/app_colors.dart';
import 'package:yahoofin/yahoofin.dart';
import 'models/stock_data.dart';

import 'elements/candlesticks.dart';
import 'models/asset.dart';

class AssetCard extends StatefulWidget {
  final Asset asset;
  AssetCard({Key? key, required this.asset}) : super(key: key);

  @override
  _AssetCardState createState() => _AssetCardState();
}

class _AssetCardState extends State<AssetCard> {
  Color textColor = Colors.white;
  bool isActive = false;
  int activeIndex = 0;
  List<Candle> candles = [];

  getDataPoints() async {
    for (int i = widget.asset.priceData.close!.length - 1; i >= 0 ; i--) {
      double open = widget.asset.priceData.open![i] == null ? 0.0 : widget.asset.priceData.open![i].toDouble();
      double high = widget.asset.priceData.high![i] == null ? 0.0 : widget.asset.priceData.high![i].toDouble();
      double low = widget.asset.priceData.low![i] == null ? 0.0 : widget.asset.priceData.low![i].toDouble();
      double close = widget.asset.priceData.close![i] == null ? 0.0 : widget.asset.priceData.close![i].toDouble();
      DateTime timestamp;
      if (widget.asset.priceData.timestamp![i] != null) {
        timestamp = DateTime.fromMillisecondsSinceEpoch(widget.asset.priceData.timestamp![i].toInt() * 1000);
        if (close != null && close > 0) {
          candles.add(Candle(date: timestamp, open: open, high: high, low: low, close: close, volume: open));
        }
      }

    }
    setState(() {
      candles = candles;
    });
  }

  Widget displayValues(String type, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    getDataPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.asset.name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ), //Company name
                const SizedBox(
                  height: 20,
                ),
                // ignore: prefer_const_constructors
                Text(
                  widget.asset.symbol,
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ), //Trading tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$${widget.asset.data.closePrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          (widget.asset.data.closePrice - widget.asset.data.openPrice) > 0 ?
                          '+${(widget.asset.data.closePrice - widget.asset.data.openPrice).toStringAsFixed(2)}'
                              : (widget.asset.data.closePrice - widget.asset.data.openPrice).toStringAsFixed(2)
                          ,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          (widget.asset.data.closePrice - widget.asset.data.openPrice) > 0 ?
                          "+" + (((widget.asset.data.closePrice - widget.asset.data.openPrice) / widget.asset.data.openPrice) * 100).toStringAsFixed(2) + " %"
                              : (((widget.asset.data.closePrice - widget.asset.data.openPrice) / widget.asset.data.openPrice) * 100).toStringAsFixed(2) + " %",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          (widget.asset.data.closePrice - widget.asset.data.openPrice) > 0 ?
                          Icons.arrow_upward
                              :
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
                Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width,
                      child: CandlesticksGraph(
                        candles: candles,
                        onIntervalChange: (String val) async {
                          // TODO: use val to get interval
                          ChartQuotes? quotes = await StockServices.getChartData(widget.asset.symbol, StockRange.fiveDay);
                          if (quotes != null) {
                            setState(() {
                              widget.asset.priceData = quotes;
                            });
                          }
                        }, interval: '1m',
                      )
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: displayValues("Open",
                          widget.asset.data.openPrice.toStringAsFixed(2))), //Open
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: displayValues("Open",
                          widget.asset.data.highPrice.toStringAsFixed(2))), //High
                ]), //Open & Close
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: displayValues("Low",
                          widget.asset.data.lowPrice.toStringAsFixed(2))), //Low
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: displayValues(
                          "52 Wk High",
                          widget.asset.data.yearHighPrice
                              .toStringAsFixed(2))), //52 Wk High
                ]), //Low & 52 Wk High
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: displayValues(
                          "52 Wk Low",
                          widget.asset.data.yearLowPrice
                              .toStringAsFixed(2))), //52 Wk Low
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: displayValues("Volume",
                          widget.asset.data.volume.toStringAsFixed(0))), //Volume
                ]), //52k low & Volum
                SizedBox(height: 20), //P/E ratio & Div/Yield

                Text(
                  "News",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 20), //P/E ratio & Div/Yield
                Text(
                  "News",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

      )
    );
  }
}
