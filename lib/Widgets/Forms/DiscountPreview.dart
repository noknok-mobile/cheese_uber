import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'DetailDiscount.dart';
import 'Forms.dart';

class DiscountPreview extends StatelessWidget implements PreferredSizeWidget{
  DiscountPreview({Key key, this.data, this.width,this.height}) : super(key: key);
  final double height;
  final double width;
  final Discount data;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(width,height);

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);

    double padding = 12 ;

    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            width: width ,
            height: height,
              decoration: BoxDecoration(
                color: ColorConstants.mainAppColor,
                borderRadius:
                BorderRadius.circular(ParametersConstants.largeImageBorderRadius),
                border:
                Border.all(color: ColorConstants.goodsBorder.withOpacity(0.1)),
                boxShadow: [
                  ParametersConstants.shadowDecoration,
                ],
              ),

             child: Stack(
               children: <Widget>[
                 data.imageUrl.isNotEmpty? CachedImage(url: data.imageUrl,width: width,height: height,):Container(),
                 Container( padding: EdgeInsets.fromLTRB(10, 10, 20, 10), child: CustomText.white14px(data.name))
               ],
             ),
          ),

        ],
      ),
      onTap:()=>{
        showModalBottomSheet(context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (buildContext){
          return DetailDiscount(discount:data ,);

        })
      },
    );
  }

}
