import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldText.dart';

import 'CheckPromocode.dart';

class CartBottomAppBar extends StatefulWidget implements PreferredSizeWidget {
  double height;
  bool isEnable = true;

  final Function onBottomButtonClick;
  SharedValue<String> promocode = SharedValue<String>();
  CartBottomAppBar(
      {@required this.height, this.onBottomButtonClick, this.isEnable = true})
      : super();

  @override
  State<StatefulWidget> createState() => _CartBottomAppBar();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class _CartBottomAppBar extends State<CartBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: widget.height,
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Row(
                  children: <Widget>[
                    CustomText.black14px(TextConstants.cartResultPrice),
                    Expanded(
                      child: Container(),
                    ),
                    AutoUpdatingWidget<CartUpdated>(
                        child: (context, e) => CustomText.black14px(
                            "${Resources().cart.cartPrice.toStringAsFixed(0)} ${TextConstants.pricePostfix}"))
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Row(
                  children: <Widget>[
                    CustomText.black14px(TextConstants.cartBonus),
                    Expanded(
                      child: Container(),
                    ),
                    AutoUpdatingWidget<CartUpdated>(
                        child: (context, e) => CustomText.black14px(
                            "${Resources().cart.bonusPoints.toStringAsFixed(0)} ${TextConstants.pricePostfix}")),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  child: AutoUpdatingWidget<CartUpdated>(child: (context, e) {
                    return Resources().cart.promocode == ""
                        ? CustomText.red14pxUnderline(
                            "${TextConstants.usePromocode}")
                        : Row(
                            children: <Widget>[
                              Icon(
                                Icons.cancel,
                                size: 15,
                                color: ColorConstants.black,
                              ),
                              CustomText.black12pxUnderline(
                                  "${Resources().cart.promocode}"),
                            ],
                          );
                  }),
                  onTap: () {
                    widget.promocode.value = "";
                    Resources().cart.promocode != ""
                        ? Resources().cart.clearDiscountData()
                        : showDialog(
                            context: context,
                            /*  */
                            builder: (context) {
                              return CheckPromocode(
                                promocode: widget.promocode,
                              );
                            },
                          );
                    Resources().cart.setPromocode = "";
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                AutoUpdatingWidget<CartUpdated>(child: (context, e) {
                  return Resources().cart.promocode == ""
                      ? Container()
                      : CustomText.black14px(
                          "${Resources().cart.discountInfo.name}");
                })
              ],
            ),
            Flexible(
              child: Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              // flex: 3,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText.black14px(
                            "${TextConstants.cartResultPrice}"),
                        AutoUpdatingWidget<CartUpdated>(
                            child: (context, e) => CustomText.red24px(
                                "${Resources().cart.resultPrice.toStringAsFixed(0)} ${TextConstants.pricePostfix}")),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    CustomButton.colored(
                      color: ColorConstants.red,
                      enable: widget.isEnable,
                      width: 190,
                      height: 45,
                      child: CustomText.white12px(
                        TextConstants.cartPlaceOrder.toUpperCase(),
                      ),
                      onClick: () => {widget.onBottomButtonClick()},
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
