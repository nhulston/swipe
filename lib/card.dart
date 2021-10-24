// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_const

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:swipe/graph_card.dart';
import 'package:swipe/chart_candles_data.dart';
import 'package:swipe/main.dart';
import 'package:swipe/services/stocks.dart';
import 'package:swipe/style/app_colors.dart';
import 'package:swipe/utils/article_display.dart';
import 'package:yahoofin/yahoofin.dart';
import 'models/stock_data.dart';
import 'package:swipe/services/api_service.dart';
import 'package:swipe/services/article_details_page.dart';
import 'package:swipe/services/article_model.dart';
import 'package:swipe/services/customListFile.dart';

import 'elements/candlesticks.dart';
import 'models/asset.dart';

class AssetCard extends StatefulWidget {
  final Asset asset;
  int? index;
  AssetCard({Key? key, required this.asset, this.index}) : super(key: key);

  @override
  AssetCardState createState() => AssetCardState();
}

class AssetCardState extends State<AssetCard> {
  Color textColor = AppColors.almostWhite;
  static AssetCardState? stateReference;
  String interval = '1D';

  getDataPoints() async {
    print('getting data points: ${widget.asset.symbol}');
    Candle? lastCandle;
    ChartCandlesData.candleData[widget.asset.symbol] = [];
    for (int i = widget.asset.priceData.close!.length - 1; i >= 0; i--) {
      double open = widget.asset.priceData.open![i] == null
          ? 0.0
          : widget.asset.priceData.open![i].toDouble();
      double high = widget.asset.priceData.high![i] == null
          ? 0.0
          : widget.asset.priceData.high![i].toDouble();
      double low = widget.asset.priceData.low![i] == null
          ? 0.0
          : widget.asset.priceData.low![i].toDouble();
      double close = widget.asset.priceData.close![i] == null
          ? 0.0
          : widget.asset.priceData.close![i].toDouble();
      DateTime timestamp;
      timestamp = DateTime.fromMillisecondsSinceEpoch(
          widget.asset.priceData.timestamp![i].toInt() * 1000);
      // print('$open, $high, $low, $close, $timestamp');
      if (close > 0) {
        lastCandle = Candle(
            date: timestamp,
            open: open,
            high: high,
            low: low,
            close: close,
            volume: open);
      } else {
        if (lastCandle != null) {
          lastCandle = Candle(
              date: timestamp,
              open: lastCandle.open,
              high: lastCandle.open,
              low: lastCandle.open,
              close: lastCandle.close,
              volume: 0);
        }
      }
      if (lastCandle != null) {
        ChartCandlesData.candleData[widget.asset.symbol]!.add(lastCandle);
      }
    }
    setState(() {});
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
    super.initState();
    getDataPoints();
  }

  @override
  Widget build(BuildContext context) {
    print('building card: ${widget.asset.symbol}, ${widget.index}');
    if (widget.index != null &&
        widget.index != -1 &&
        widget.index! < MyHomePageState.currentlyViewedIndex!) {
      MyHomePageState.stocks.removeAt(widget.index!);
      //this.dispose();
      return Text('');
    }
    if (ChartCandlesData.candleData[widget.asset.symbol] == null) {
      getDataPoints();
      return Text('');
    } else {
      print(
          '${widget.asset.symbol}, ${ChartCandlesData.candleData[widget.asset.symbol]![0].close}');
    }
    Color directionColor =
        (widget.asset.data.closePrice - widget.asset.data.openPrice) > 0
            ? Color.fromARGB(255, 2, 192, 119)
            : Color.fromARGB(255, 207, 48, 74);
    // print('building card: ${widget.asset.symbol}, ${ChartCandlesData.candleData[widget.asset.symbol]![ChartCandlesData.candleData[widget.asset.symbol]!.length - 1].close}, ${widget.asset.data.closePrice}');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xff0f0f0f),
          borderRadius: BorderRadius.circular(20),
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
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          (widget.asset.data.closePrice -
                                      widget.asset.data.openPrice) >
                                  0
                              ? '+${(widget.asset.data.closePrice - widget.asset.data.openPrice).toStringAsFixed(2)}'
                              : (widget.asset.data.closePrice -
                                      widget.asset.data.openPrice)
                                  .toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: directionColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          (widget.asset.data.closePrice -
                                      widget.asset.data.openPrice) >
                                  0
                              ? "+" +
                                  (((widget.asset.data.closePrice -
                                                  widget.asset.data.openPrice) /
                                              widget.asset.data.openPrice) *
                                          100)
                                      .toStringAsFixed(2) +
                                  " %"
                              : (((widget.asset.data.closePrice -
                                                  widget.asset.data.openPrice) /
                                              widget.asset.data.openPrice) *
                                          100)
                                      .toStringAsFixed(2) +
                                  " %",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: directionColor,
                          ),
                        ),
                        Icon(
                          (widget.asset.data.closePrice -
                                      widget.asset.data.openPrice) >
                                  0
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: directionColor,
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
                        candles:
                            ChartCandlesData.candleData[widget.asset.symbol]!,
                        onIntervalChange: (String val) async {
                          interval = val;
                          StockRange range;
                          switch (val) {
                            case '1D':
                              range = StockRange.oneDay;
                              break;
                            case '5D':
                              range = StockRange.fiveDay;
                              break;
                            case '1M':
                              range = StockRange.oneMonth;
                              break;
                            case '3M':
                              range = StockRange.threeMonth;
                              break;
                            case '1Y':
                              range = StockRange.oneYear;
                              break;
                            case '5Y':
                              range = StockRange.fiveYear;
                              break;
                            default:
                              range = StockRange.maxRange;
                          }

                          ChartQuotes? quotes =
                              await StockServices.getChartData(
                                  widget.asset.symbol, range);
                          if (quotes != null) {
                            setState(() {
                              print(quotes.close);
                              widget.asset.priceData = quotes;
                              getDataPoints();
                            });
                          }
                        },
                        interval: interval,
                        intervals: const ['1D', '5D', '1M', '3M', '1Y', '5Y'],
                      )),
                ),

                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: displayValues(
                              "Open",
                              widget.asset.data.openPrice
                                  .toStringAsFixed(2))), //Open
                      SizedBox(width: 10),
                      Expanded(
                          flex: 1,
                          child: displayValues(
                              "Open",
                              widget.asset.data.highPrice
                                  .toStringAsFixed(2))), //High
                    ]), //Open & Close
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: displayValues(
                              "Low",
                              widget.asset.data.lowPrice
                                  .toStringAsFixed(2))), //Low
                      SizedBox(width: 10),
                      Expanded(
                          flex: 1,
                          child: displayValues(
                              "52 Wk High",
                              widget.asset.data.yearHighPrice
                                  .toStringAsFixed(2))), //52 Wk High
                    ]), //Low & 52 Wk High
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: displayValues(
                              "52 Wk Low",
                              widget.asset.data.yearLowPrice
                                  .toStringAsFixed(2))), //52 Wk Low
                      SizedBox(width: 10),
                      Expanded(
                          flex: 1,
                          child: displayValues(
                              "Volume",
                              widget.asset.data.volume
                                  .toStringAsFixed(0))), //Volume
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
      ),
    );
  }
}
