import 'package:flutter/material.dart';
import 'package:swipe/style/radiant_gradient_mask.dart';

class MyNavBar extends StatefulWidget {
  final Function() notifyParent;
  const MyNavBar({Key? key, required this.notifyParent}) : super(key: key);

  @override
  MyNavBarState createState() => MyNavBarState();
}

class MyNavBarState extends State<MyNavBar> {
  static int bottomNavIndex = 0;

  void _onBottomNavTapped(int index) {
    setState(() {
      bottomNavIndex = index;
      widget.notifyParent();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image(
            height: screenHeight / 30,
            image: AssetImage(bottomNavIndex == 0 ? 'assets/s.png' : 'assets/s_gray.png'),
          ),
          title: const SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: bottomNavIndex == 0 ? Icon(
            Icons.grid_view,
            size: screenHeight / 30,
          ) : RadiantGradientMask(
              child: Icon(
                Icons.grid_view,
                size: screenHeight / 30,
              )
          ),
          title: const SizedBox.shrink(),
        ),
      ],
      currentIndex: bottomNavIndex,
      onTap: _onBottomNavTapped,
    );
  }
}
