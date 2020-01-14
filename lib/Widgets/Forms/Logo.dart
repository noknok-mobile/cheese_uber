import 'package:flutter/cupertino.dart';
import 'package:flutter_cheez/Resources/Resources.dart';

class Logo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Stack(children: <Widget>[
      const Image( image: AssetImage("lib/assets/images/logo.png"),),

    ],);
  }


}