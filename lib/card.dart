import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:swipe/chart_candles_data.dart';
import 'package:swipe/main.dart';
import 'package:swipe/services/stocks.dart';
import 'package:yahoofin/yahoofin.dart';
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

  static AssetCardState? stateReference;

  getDataPoints() async {
    print('getting data points: ${widget.asset.symbol}');
    Candle? lastCandle;
    ChartCandlesData.candleData[widget.asset.symbol] = [];
    for (int i = widget.asset.priceData.close!.length - 1; i >= 0 ; i--) {
      double open = widget.asset.priceData.open![i] == null ? 0.0 : widget.asset.priceData.open![i].toDouble();
      double high = widget.asset.priceData.high![i] == null ? 0.0 : widget.asset.priceData.high![i].toDouble();
      double low = widget.asset.priceData.low![i] == null ? 0.0 : widget.asset.priceData.low![i].toDouble();
      double close = widget.asset.priceData.close![i] == null ? 0.0 : widget.asset.priceData.close![i].toDouble();
      DateTime timestamp;
      timestamp = DateTime.fromMillisecondsSinceEpoch(widget.asset.priceData.timestamp![i].toInt() * 1000);
      // print('$open, $high, $low, $close, $timestamp');
      if (close > 0) {
        lastCandle = Candle(date: timestamp, open: open, high: high, low: low, close: close, volume: open);
      } else {
        if (lastCandle != null) {
          lastCandle = Candle(date: timestamp, open: lastCandle.open, high: lastCandle.open, low: lastCandle.open, close: lastCandle.close, volume: 0);
        }
      }
      if (lastCandle != null) {
        ChartCandlesData.candleData[widget.asset.symbol]!.add(lastCandle);
      }


    }
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    getDataPoints();
  }

  @override
  Widget build(BuildContext context) {
    print('building card: ${widget.asset.symbol}, ${widget.index}');
    if (widget.index != null && widget.index != -1 && widget.index! < MyHomePageState.currentlyViewedIndex!) {
      this.dispose();
      return Text('');
    }
    if (ChartCandlesData.candleData[widget.asset.symbol] == null) {
      getDataPoints();
      return Text('');
    } else {
      print('${widget.asset.symbol}, ${ChartCandlesData.candleData[widget.asset.symbol]![0].close}');
    }
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
                        candles: ChartCandlesData.candleData[widget.asset.symbol]!,
                        onIntervalChange: (String val) async {
                          StockRange interval;
                          switch (val) {
                            case '1D':
                              interval = StockRange.oneDay;
                              break;
                            case '5D':
                              interval = StockRange.fiveDay;
                              break;
                            case '1M':
                              interval = StockRange.oneMonth;
                              break;
                            case '3M':
                              interval = StockRange.threeMonth;
                              break;
                            case '1Y':
                              interval = StockRange.oneYear;
                              break;
                            case '5Y':
                              interval = StockRange.fiveYear;
                              break;
                            default:
                              interval = StockRange.maxRange;
                          }

                          ChartQuotes? quotes = await StockServices.getChartData(widget.asset.symbol, interval);
                          if (quotes != null) {
                            setState(() {
                              print(quotes.close);
                              widget.asset.priceData = quotes;
                            });
                          }
                        },
                        interval: '1D',
                        intervals: const [
                          '1D',
                          '5D',
                          '1M',
                          '3M',
                          '1Y',
                          '5Y'
                        ],
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Open",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: const [
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
                      )
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
                                style: const TextStyle(
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
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )), //Low
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
                                style: const TextStyle(
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
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      )), //52 Wk Low
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
                                style: const TextStyle(
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
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Avg Vol",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: const [
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
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Mkt Cap",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: const [
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
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "P/E Ratio",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: const [
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
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Div/Yield",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: const [
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
                const SizedBox(height: 20), //P/E ratio & Div/Yield
                const Text(
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
