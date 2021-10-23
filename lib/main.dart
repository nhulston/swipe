import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:swipe/Style/app_colors.dart';
import 'package:swipe/Style/radiant_gradient_mask.dart';
import 'package:tcard/tcard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '\$wipe',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Color> colors = [
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.orange,
  Colors.pink,
  Colors.amber,
  Colors.cyan,
  Colors.purple,
  Colors.brown,
  Colors.teal,
];

List<Widget> cards = List.generate(
  colors.length,
      (int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors[index],
      ),
      child: Text(
        '${index + 1}',
        style: TextStyle(fontSize: 100.0, color: Colors.white),
      ),
    );
  },
);

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {

              },
              icon: RadiantGradientMask(
                child: Icon(
                  Icons.account_circle,
                  color: AppColors.red,
                  size: screenWidth / 10,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(top: screenHeight / 300),
              child: Image(
                height: screenWidth / 5,
                image: const AssetImage('assets/logo.png'),
              ),
            ),
            SizedBox(width: screenWidth / 11),
            const Spacer(),
          ],
        ),
      ),
      body: TCard(
        cards: cards,
        onForward: (int x, SwipInfo info) {
          log('$x');
          log('${info.cardIndex}');
        },
        onBack: (int x, SwipInfo info) {
          log('$x');
          log('${info.cardIndex}');
        },
      )
    );
  }
}
