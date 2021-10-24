// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:swipe/graph_card.dart';

class AssetCard extends StatefulWidget {
  const AssetCard({Key? key}) : super(key: key);

  @override
  _AssetCardState createState() => _AssetCardState();
}

class _AssetCardState extends State<AssetCard> {
  Color color = Colors.white;
  Color fcolor = Colors.grey;
  bool isActive = false;
  int activeIndex = 0;

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
                "Apple Inc.",
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
                "APPL",
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
                        "148.69",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "-0.79 ",
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
                        "-0.53%",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                      Icon(
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
                    xAxisCustomValues: [1, 5, 10, 15, 20, 25, 30],
                    series: const [
                      BezierLine(
                        label: "june",
                        lineColor: Colors.orange,
                        dataPointStrokeColor: Colors.orange,
                        dataPointFillColor: Colors.orange,
                        lineStrokeWidth: 3,
                        data: const [
                          DataPoint<double>(value: 100, xAxis: 1),
                          DataPoint<double>(value: 130, xAxis: 5),
                          DataPoint<double>(value: 300, xAxis: 10),
                          DataPoint<double>(value: 150, xAxis: 15),
                          DataPoint<double>(value: 75, xAxis: 20),
                          DataPoint<double>(value: 100, xAxis: 25),
                          DataPoint<double>(value: 250, xAxis: 30),
                        ],
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
                              "150.18",
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
                              "148.64",
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
                              "157.26",
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
                              "107.32",
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
                              "107.32",
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
    );
  }
}
