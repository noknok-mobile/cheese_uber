import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Drawers/MySnackBar.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter/services.dart';
import 'AutoUpdatingWidget.dart';


class DetailDiscount extends StatefulWidget {
  final Discount discount;
  const DetailDiscount({
    Key key,
    this.discount,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailDiscountState();
}

class _DetailDiscountState extends State<DetailDiscount> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height<1000?170:250;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      body: Builder(
        builder: (ctx) => Container(
          height: 500,

          decoration: BoxDecoration(
            color: Color.fromARGB(0, 0, 0, 0),
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                    ParametersConstants.largeImageBorderRadius)),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                color: Color.fromARGB(0, 0, 0, 0),
                height: height,
                child: Stack(
                  children: <Widget>[
                    Container(
                        color: Color.fromARGB(0, 0, 0, 0),
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(bottom: 20),
                        width: 9999,
                        child: CachedImage(url: widget.discount.detailImageUrl)),
                    Container(

                      alignment: Alignment.bottomLeft,
                      color: Color.fromARGB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 100),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              padding: EdgeInsets.all(0),
                              icon: IconConstants.arrowDown,
                              onPressed: () => {Navigator.of(context).pop()},
                            ),
                            SizedBox(
                              width: 30,
                              height: 0,
                            ),
                            Expanded(
                                child: CustomText.white24px(
                              widget.discount.name,
                              maxLines: 2,
                            )),
                          ]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:height- 100),
                child: Container(

                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      color: ColorConstants.mainAppColor,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                              ParametersConstants.largeImageBorderRadius)),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            CustomText.black16px(
                              widget.discount.detailText,
                              maxLines: 7,
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            widget.discount.coupon!=""?   GestureDetector(
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      AssetsConstants.discountBG,
                                      CustomText.black24px( widget.discount.coupon,maxLines: 1,align: TextAlign.center,),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Clipboard.setData(new ClipboardData(
                                      text: widget.discount.coupon));

                                  Scaffold.of(ctx).showSnackBar(MySnackBar.build(context:ctx , message:TextConstants.textCopy,type:SnackBatMessageType.info));
                                }):Container(),
                          ],
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
