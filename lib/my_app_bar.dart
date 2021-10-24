import 'package:flutter/material.dart';
import 'Style/app_colors.dart';
import 'Style/radiant_gradient_mask.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : preferredSize = const Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize;

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool _assetIsCrypto = true;

  void _onAssetTypeTapped() {
    setState(() {
      _assetIsCrypto = !_assetIsCrypto;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          // Profile Icon
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

          // Logo
          Padding(
            padding: EdgeInsets.only(top: screenHeight / 300),
            child: Image(
              height: screenWidth / 5,
              image: const AssetImage('assets/logo.png'),
            ),
          ),
          const Spacer(),
          SizedBox(width: screenWidth / 10),
        ],
      ),
    );
  }
}
