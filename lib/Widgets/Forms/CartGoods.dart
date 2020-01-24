import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Forms/Goods.dart';

import 'Forms.dart';

class CartGoods extends StatefulWidget implements PreferredSizeWidget {
  final GoodsData data;

  CartGoods({this.data});
  @override
  _CartGoodsState createState() => _CartGoodsState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(124);
}

class _CartGoodsState extends State<CartGoods> with TickerProviderStateMixin {
  Goods goods;
  double horizontalPosition = 0;
  double maxHorisontalPosition = -60;

  void initState() {
    super.initState();
    goods = Goods(
      data: widget.data,
      height: widget.preferredSize.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    bool show  = Resources().cart.getCount(widget.data.id) > 0;
    return AnimatedContainer(

      duration: Duration(milliseconds: 200),
      padding: show ?const EdgeInsets.all(0) :  const EdgeInsets.fromLTRB(100, 0, 16, 16),
      margin: show ?  const EdgeInsets.fromLTRB(0, 3,0, 3):const EdgeInsets.all(0),
      height: show ? widget.preferredSize.height : 0,
      //left: horizontalPosition,


      child: Stack(

          children: <Widget>[

        new Container(
            width: c_width,
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: CustomButton(
                height: widget.preferredSize.height -1,
                width: maxHorisontalPosition.abs(),
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(
                        ParametersConstants.largeImageBorderRadius),
                    color: ColorConstants.red),
                onClick: () =>
                    setState(() => Resources().cart.removeAll(widget.data.id)
                    ),
                child: const Icon(
                  Icons.delete_forever,
                  color: ColorConstants.mainAppColor,
                  size: 32,
                ),
              ),
            )),
        AnimatedPositioned(
          duration: Duration(milliseconds: 100),
          left: horizontalPosition,
          width: c_width,

          child: GestureDetector(

            onHorizontalDragEnd: (d) {
              setState(() {
                if (horizontalPosition > 0.4 * maxHorisontalPosition)
                  horizontalPosition = 0;
                else
                  horizontalPosition = maxHorisontalPosition;
              });
            },
            onHorizontalDragUpdate: (d) {
              if (d.primaryDelta >= 1.0 || d.primaryDelta <= -1.0) {
                //print(d.primaryDelta);
                setState(() {
                  horizontalPosition += d.primaryDelta;
                  horizontalPosition =
                      horizontalPosition.clamp(maxHorisontalPosition, 0.0);
                });
              }
            },
            child: goods,
          ),
        ),
      ]),
    );
  }
}
