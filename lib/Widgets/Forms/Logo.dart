import 'package:flutter/cupertino.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';

class Logo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Stack(children: <Widget>[

       Image( image:AssetsConstants.logo),

    ],);
  }


}