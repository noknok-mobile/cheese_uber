import 'package:flutter/cupertino.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';

class CartBottomAppBar extends StatefulWidget implements PreferredSizeWidget {
  double height;

  CartBottomAppBar({@required this.height}):super();

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
              alignment:Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Row(
                  children: <Widget>[
                    CustomText.black14px(TextConstants.cartPrice),
                    Expanded(

                      child: Container(),
                    ),
                    AutoUpdatingWidget<CartUpdated>(child:(context)=> CustomText.black14px("${Resources().cart.cartPrice.toString()} ${TextConstants.pricePostfix}"))
                  ],
                ),
              ),
            ),
            Align(

              alignment:Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Row(
                  children: <Widget>[
                    CustomText.black14px(TextConstants.cartBonus),
                    Expanded(
                      child: Container(),
                    ),
                    AutoUpdatingWidget<CartUpdated>(child:(context)=> CustomText.black14px("${Resources().cart.bonusPoints.toString()} ${TextConstants.pricePostfix}"))
                  ],
                ),
              ),
            ),
            Flexible(
              child:Container(),

            ),
            Align(
              alignment:Alignment.bottomCenter,
             // flex: 3,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText.black14px("${TextConstants.cartResultPrice}"),

                        AutoUpdatingWidget<CartUpdated>(child:(context)=> CustomText.red24px("${ Resources().cart.resultPrice.toString()} ${TextConstants.pricePostfix}")),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    CustomButton.colored(color:ColorConstants.red, width: 190,height: 45,child:CustomText.white12px(TextConstants.cartPlaceOrder),onClick: ()=>{},)

                  ],
                ),
              ),
            )
          ],
        ));
  }
}
