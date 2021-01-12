import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetsConstants.splashBackground,
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(Colors.blue, BlendMode.colorBurn)
        ),
      ),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
