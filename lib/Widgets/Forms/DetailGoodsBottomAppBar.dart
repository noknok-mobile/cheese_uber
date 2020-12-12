import 'package:flutter/cupertino.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Buttons/CountButtonGroup.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Pages/CartPage.dart';

class DetailGoodsBottomAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final double height;

  final GoodsData goodItem;

  DetailGoodsBottomAppBar({@required this.height, this.goodItem}) : super();

  @override
  State<StatefulWidget> createState() => _DetailGoodsBottomAppBarBottomAppBar();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class _DetailGoodsBottomAppBarBottomAppBar
    extends State<DetailGoodsBottomAppBar> {
  int countToAdd;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: ColorConstants.mainAppColor,
          border: Border.all(color: ColorConstants.gray),
          boxShadow: [
            ParametersConstants.shadowDecoration,
          ],
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: widget.height,
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText.black14px("${TextConstants.cartResultPrice}"),
                    AutoUpdatingWidget<CartUpdated>(
                        child: (context, e) => CustomText.red24px(
                            "${Resources().cart.getCount(widget.goodItem.id) * (widget.goodItem.getPrice().price + 0.4).round()} ${TextConstants.pricePostfix}")),
                  ],
                ),
                Flexible(
                  child: Container(),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: CountButtonGroup(
                      step: widget.goodItem.units == "шт" ? 1 : 0.25,
                      getText: () {
                        return "${widget.goodItem.units == "шт" ? Resources().cart.getCount(widget.goodItem.id).toInt() : Resources().cart.getCount(widget.goodItem.id).toStringAsFixed(2)} ${widget.goodItem.units}";
                      },
                      setCount: (double count) => {
                        Resources().cart.setCount(widget.goodItem.id, count)
                      },
                      getCount: () {
                        return Resources().cart.getCount(widget.goodItem.id);
                      },
                    )),
              ],
            ),
            Flexible(
              child: Container(),
            ),
            CustomButton.colored(
              expanded: true,
              color: ColorConstants.red,
              height: 45,
              child: CustomText.white12px(
                  TextConstants.cartAddToOrder.toUpperCase()),
              onClick: () => {
                Navigator.push(
                  context,
                  CartButtonRoute(builder: (context) => CartPage()),
                )
              },
            )
          ],
        ));
  }
}
