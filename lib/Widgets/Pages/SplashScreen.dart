import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFB904),
      child: Center(
        child: Container(
          width: 300,
          height: 215,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetsConstants.splashBackground,
              // colorFilter: ColorFilter.mode(Colors.blue, BlendMode.colorBurn)
            ),
          ),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
