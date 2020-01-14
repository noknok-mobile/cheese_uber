
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';

class LeftMenu extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shop, size: 128.0, color: textStyle.color),
            Text(TextConstants.legtMenuHeader, style: textStyle),
          ],
        ),
      ),
    );
  }
}
