import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return Container(

        decoration: BoxDecoration(
          image: DecorationImage(

            image: AssetImage("lib/assets/backgrounds/splash_screen.png"),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(Colors.blue, BlendMode.colorBurn)
          ),
        ),
        child: Center(child: CircularProgressIndicator()));
  }
}


