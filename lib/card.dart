// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_const

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:swipe/graph_card.dart';
import 'package:swipe/services/stocks.dart';
import 'package:swipe/style/app_colors.dart';
import 'package:yahoofin/yahoofin.dart';

import 'elements/candlesticks.dart';
import 'models/asset.dart';

class AssetCard extends StatefulWidget {
  final Asset asset;
  AssetCard({Key? key, required this.asset}) : super(key: key);

  @override
  _AssetCardState createState() => _AssetCardState();
}

class _AssetCardState extends State<AssetCard> {
  Color color = Colors.white;
  Color fcolor = Colors.grey;
  bool isActive = false;
  int activeIndex = 0;
  List<Candle> candles = [
  ];

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF000000), Color(0xFF000000)]
          )
        ),
        child:SingleChildScrollView(
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
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ), //Company name
                SizedBox(
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
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          (widget.asset.data.closePrice - widget.asset.data.openPrice) > 0 ?
                          '+${(widget.asset.data.closePrice - widget.asset.data.openPrice).toStringAsFixed(2)}'
                              : '${(widget.asset.data.closePrice - widget.asset.data.openPrice).toStringAsFixed(2)}'
                          ,
                          style: TextStyle(
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
                          style: TextStyle(
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
                  child: Container(
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

                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Open",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "149.64",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )), //Open
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "High",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.asset.data.highPrice.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )), //High
                ]), //Open & Close
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Low",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.asset.data.lowPrice.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )), //Low
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "52 Wk High",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.asset.data.yearHighPrice.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )), //52 Wk High
                ]), //Low & 52 Wk High
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "52 Wk Low",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.asset.data.yearLowPrice.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )), //52 Wk Low
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Volume",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.asset.data.volume.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )), //Volume
                ]), //52k low & Volume
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Avg Vol",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "69.46M",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mkt Cap",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "2.46T",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ]), //Avg Vol & Mkt Cap
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "P/E Ratio",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "29.12",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Div/Yield",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "0.57",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ]),
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
