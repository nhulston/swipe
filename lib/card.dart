// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:swipe/graph_card.dart';

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
  List<double> xValues = [];
  List<DataPoint> dataPoints = [];

  getDataPoints() {
    for (int i = 0; i < widget.asset.priceData.close!.length; i++) {
      double price = widget.asset.priceData.close![i] == null ? 0.0 : widget.asset.priceData.close![i].toDouble();
      double timestamp = widget.asset.priceData.timestamp![i].toDouble();
      if (price != null && price > 0) {
        print('${widget.asset.name}, ${widget.asset.data.closePrice}, $timestamp, $price');
        xValues.add(i.toDouble());
        dataPoints.add(DataPoint(value: price, xAxis: timestamp));
      }
    }
    setState(() {
      dataPoints = dataPoints;
    });
  }

  Widget showPrices(String type, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
                          color: Colors.orange,
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
                          color: Colors.orange,
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
                  child: BezierChart(
                    bezierChartScale: BezierChartScale.CUSTOM,
                    selectedValue: 1,
                    xAxisCustomValues: xValues,
                    series: [
                      BezierLine(
                        label: "june",
                        lineColor: Colors.orange,
                        dataPointStrokeColor: Colors.orange,
                        dataPointFillColor: Colors.orange,
                        lineStrokeWidth: 3,
                        data: dataPoints,
                      ),
                    ],
                    config: BezierChartConfig(
                      startYAxisFromNonZeroValue: true,
                      verticalIndicatorFixedPosition: false,
                      bubbleIndicatorColor: Colors.black,
                      bubbleIndicatorLabelStyle: TextStyle(color: Colors.white),
                      bubbleIndicatorTitleStyle: TextStyle(color: Colors.white),
                      bubbleIndicatorValueStyle: TextStyle(color: Colors.white),
                      footerHeight: 40,
                      displayYAxis: false,
                      stepsYAxis: 15,
                      displayLinesXAxis: false,
                      xAxisTextStyle: TextStyle(
                        color: Colors.black,
                      ),
                      backgroundGradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.black,
                          Colors.black,
                          Colors.black
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      snap: false,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        "5 days",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GraphCardWidget(
                    title: "5 D",
                    activeColor: color,
                    fontColor: fcolor,
                    isActive: isActive,
                    activeIndex: activeIndex,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GraphCardWidget(
                    title: "1 W",
                    activeColor: color,
                    fontColor: fcolor,
                    isActive: isActive,
                    activeIndex: activeIndex,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GraphCardWidget(
                    title: "1 M",
                    activeColor: color,
                    fontColor: fcolor,
                    isActive: isActive,
                    activeIndex: activeIndex,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GraphCardWidget(
                    title: "3 M",
                    activeColor: color,
                    fontColor: fcolor,
                    isActive: isActive,
                    activeIndex: activeIndex,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GraphCardWidget(
                    title: "1 Y",
                    activeColor: color,
                    fontColor: fcolor,
                    isActive: isActive,
                    activeIndex: activeIndex,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GraphCardWidget(
                    title: "5 Y",
                    activeColor: color,
                    fontColor: fcolor,
                    isActive: isActive,
                    activeIndex: activeIndex,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              // Open & Close
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(flex: 1, child: showPrices("Open", "149.64")), //Open
                SizedBox(width: 10),
                Expanded(flex: 1, child: showPrices("High", "149.64")), //High
              ]),
              SizedBox(height: 10),
              // Low & 52 Wk High
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  flex: 1,
                  child: showPrices("Low", "148.64"),
                ),
                SizedBox(width: 10),
                Expanded(
                    flex: 1,
                    child: showPrices("52 Wk High", "149.64")), //52 Wk High
              ]),
              SizedBox(height: 10),
              // 52k low & Volume
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    flex: 1,
                    child: showPrices("52 Wk Low", "149.64")), //52 Wk Low
                SizedBox(width: 10),
                Expanded(
                    flex: 1, child: showPrices("Volume", "149.64")), //Volume
              ]),
              SizedBox(height: 10),
              // Avg Vol & Mkt Cap
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(flex: 1, child: showPrices("Avg Vol", "149.64")),
                SizedBox(width: 10),
                Expanded(flex: 1, child: showPrices("Mkt Cap", "149.64")),
              ]), //Avg Vol & Mkt Cap
              SizedBox(height: 10),
              // P/E ratio & Div/Yield
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(flex: 1, child: showPrices("P/E ratio", "149.64")),
                SizedBox(width: 10),
                Expanded(flex: 1, child: showPrices("Div/Yield", "149.64")),
              ]),
              SizedBox(height: 20),
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
    );
  }
}
