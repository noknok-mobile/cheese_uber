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



class CartGoods extends StatefulWidget {
  final GoodsData data;

  CartGoods({this.data});
  @override
  _CartGoodsState createState() => _CartGoodsState();

}

class _CartGoodsState extends State<CartGoods> with TickerProviderStateMixin{
  Goods goods;
  double horizontalPosition = 0;
  double maxHorisontalPosition = -100;
  void initState() {
    super.initState();
    goods = Goods(data:widget.data);
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width*0.5;
    return Stack(

        children: <Widget>[

          new Container(

    /*
              margin: EdgeInsets.fromLTRB(20,3,3,20),
              padding: EdgeInsets.fromLTRB(0,3,3,0),*/
              alignment: Alignment.centerRight,
              child:
              Padding(
                padding: const EdgeInsets.fromLTRB(15,3,3,3),

                child: MaterialButton (
                    height: 155,
                    onPressed: ()=>setState(() => Resources().cart.removeAll(widget.data.id)),
                    child: const Icon(Icons.minimize),
                    color:ColorConstants.red
                ),
              )
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 50),
            right:horizontalPosition,

               child: GestureDetector(
                 onHorizontalDragEnd: (d){

                     setState(() {
                       if (horizontalPosition > 0.5 * maxHorisontalPosition)
                         horizontalPosition = 0;
                       else
                         horizontalPosition = maxHorisontalPosition;
                     });

                  },
                  onHorizontalDragUpdate: (d) {
                    if(d.primaryDelta >= 1.0 || d.primaryDelta <= - 1.0)
                    {
                      //print(d.primaryDelta);
                      setState(() {
                        horizontalPosition+= d.primaryDelta;
                        horizontalPosition = horizontalPosition.clamp(maxHorisontalPosition, 0.0);
                      });
                    }
                  },

                 child:  goods,
            ),
             ),
           ]);
  }
}
