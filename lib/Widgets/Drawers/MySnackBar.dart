import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/Logo.dart';
import 'package:flutter_cheez/Widgets/Pages/CartPage.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';
import 'package:flutter_cheez/Widgets/Pages/ChangeCity.dart';
import 'package:flutter_cheez/Widgets/Pages/InformationPage.dart';
import 'package:flutter_cheez/Widgets/Pages/OrdersPage.dart';
import 'package:flutter_cheez/Widgets/Pages/SelectShop.dart';
import 'package:flutter_cheez/Widgets/Pages/UserInfo.dart';
import 'package:flutter_svg/svg.dart';

enum SnackBatMessageType{
  info,error,warning

}
class MySnackBar {

  static SnackBar build({BuildContext context,String message,SnackBatMessageType type, double height = 30,Function onTap}) {
    return SnackBar(

      elevation: 0,
        //behavior: SnackBarBehavior.floating,
        backgroundColor: ColorConstants.blackTransparent,
        content: GestureDetector(

      onTap: (){
        if(onTap != null)
          onTap();
        Scaffold.of(context).hideCurrentSnackBar();

      },
      child: Container(
        transform: Matrix4.translationValues(-25, 0, 0),
        height: height,
        child: Row(

          children: <Widget>[
            Container(transform:Matrix4.translationValues(0, -20, 0)* Matrix4.diagonal3Values(1,3,1),width: 10, height: 99999, color:getColor(type) ,),
            Container(padding: EdgeInsets.only(left: 10), child: getIcon(type)),
            Container(transform: Matrix4.translationValues(-25, -20, -20),width: 10,height: 1,),
            Text(message),
          ],
        ),
      )),

    );
  }
  static Color getColor(SnackBatMessageType type){
    switch(type){
      case SnackBatMessageType.info:
        return ColorConstants.orderDelivery;
      case SnackBatMessageType.error:
        return ColorConstants.orderPay;
      case SnackBatMessageType.info:
        return ColorConstants.orderCall;
      default :
        return ColorConstants.orderDone;

    }
  }
  static Widget getIcon(SnackBatMessageType type){
    switch(type){
      case SnackBatMessageType.info:
        return Icon(Icons.info_outline) ;
      case SnackBatMessageType.error:
        return Icon(Icons.info_outline) ;
      case SnackBatMessageType.info:
        return Icon(Icons.info_outline) ;
      default :
        return Icon(Icons.info_outline) ;

    }
  }
}
