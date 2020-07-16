import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/PriceTextField.dart';
import 'package:flutter_cheez/Widgets/Pages/CartPage.dart';
import 'package:flutter_cheez/Widgets/Pages/DetailGoods.dart';
import 'package:flutter_cheez/Widgets/Pages/WebPage.dart';
import 'package:intl/intl.dart';

import 'InformationRow.dart';

class Order extends StatefulWidget implements PreferredSizeWidget {
  final OrderData data;

  Order({Key key, this.data}) : super(key: key);

  Widget _getDetailInfo(OrderData _data) {}



  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;

  @override
  State<StatefulWidget> createState() =>_stateOrder();
}
class _stateOrder extends State<Order>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: ColorConstants.mainAppColor,
        borderRadius:
        BorderRadius.circular(ParametersConstants.largeImageBorderRadius),
      ),
      child: FlatButton(
        padding: const EdgeInsets.all(0),
        onPressed: () => {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(
                      ParametersConstants.largeImageBorderRadius)),
              builder: (context) {
                return Container(
                  margin: EdgeInsets.all(20),
                  child: Column(

                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 10),
                            onPressed: () => {Navigator.pop(context)},
                            icon: IconConstants.arrowDownBlack,
                          ),
                          Expanded(
                              child: CustomText.black24px(
                                  "${TextConstants.orderNumber} ${widget.data.id.toString()}")),
                          Container(
                            width: 130,
                            height: 25,
                            decoration: BoxDecoration(
                              color: _getColor(widget.data.status),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  ParametersConstants.largeImageBorderRadius)),
                            ),
                            alignment: Alignment.center,
                            child: _getText(widget.data.status),
                          )
                        ],
                      ),
                      Container(
                        height:210,
                        child: ListView(
                          shrinkWrap: true,

                          children: <Widget>[
                            Container(height: 20,),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.data.cart.cart.keys.length,

                                itemBuilder: (context, index) {
                                  return FlatButton(
                                    onPressed: ()=>{
                                      Navigator.of(context).push(new MaterialPageRoute(builder:(context){ return  DetailGoods(goodsData: Resources().getGodById(widget.data.cart.cart.keys.elementAt(index)),);}))

                                    },
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: CustomText.black16px(
                                              "${Resources().getGodById(widget.data.cart.cart.keys.elementAt(index)).name}",maxLines: 2,),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: CustomText.black16px(
                                                "${widget.data.cart.cart[widget.data.cart.cart.keys.elementAt(index)]} x "
                                                    "${widget.data.cart.savedCartPrice.values.elementAt(index)}${TextConstants.pricePostfix}"),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: CustomText.black16px(
                                                "${widget.data.cart.savedCartPrice.values.elementAt(index) * widget.data.cart.cart[widget.data.cart.cart.keys.elementAt(index)]}${TextConstants.pricePostfix}",
                                                maxLines: 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            InformationRow(icon: AssetsConstants.iconInfoPay,label: TextConstants.payMethod,text: widget.data.payType == PayType.cash?TextConstants.payMethodCash:TextConstants.payMethodOnline,),
                            Container(height: 10,),
                            InformationRow(icon: AssetsConstants.iconInfoDelivery,label: TextConstants.delivery,text: widget.data.deliveryType == DeliveryType.courier?TextConstants.deliveryMethodCourier:TextConstants.deliveryMethodPickup,),
                            Container(height: 10,),
                            InformationRow(icon: AssetsConstants.iconInfoTime,label: TextConstants.deliveryTime,text: "${DateFormat.d().format(widget.data.orderTime)}.${DateFormat.M().format(widget.data.orderTime)}.${DateFormat.y().format(widget.data.orderTime)}  ${DateFormat.Hm().format(widget.data.orderTime)}",),
                            Container(height: 10,),
                            InformationRow(icon: AssetsConstants.iconInfoUser,label: TextConstants.contactName,text: widget.data.userAddress.username,),
                            Container(height: 10,),
                            InformationRow(icon: AssetsConstants.iconInfoAdres,label: TextConstants.adres,text:widget.data.userAddress.addres ,),
                            Container(height: 20,),
                          ],
                        ),
                      ),
                      Container(height: 1,margin: const EdgeInsets.only(bottom: 10),color: ColorConstants.darkGray,),
                      Row(
                        children: <Widget>[

                          Expanded(child: PriceRow(text: widget.data.cart.cartPrice,)),
                          widget.data.status == "ON"?
                          CustomButton.colored(color:ColorConstants.red,enable: !used, width: 190,height: 45,child:CustomText.white12px(TextConstants.orderMakePay),onClick: ()async{

                            if(used){
                              return;

                            }
                            used = true;
                            setState(() {

                            });

                            String href =  await Resources().getPayment(widget.data.id);

                            Navigator.push(
                                context,
                                MaterialPageRoute( builder: (context) => WebPage(title:TextConstants.orderSberbankPay ,url:href)));
                            used = false;
                            setState(() {

                            });
                          },):_duplicateOrder(context)
                        ],
                      ),
                    ],
                  ),
                );
              }),
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: CustomText.black16px(
                          "${TextConstants.orderNumber} ${widget.data.id.toString()}")),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5.0),
                    child: CustomText.black18pxBold(
                        "${widget.data.cart.cartPrice.toString()} ${TextConstants.pricePostfix}"),
                  ),
                  CustomText.gray12px(
                      "${DateFormat.d().format(widget.data.orderTime)}.${DateFormat.M().format(widget.data.orderTime)}.${DateFormat.y().format(widget.data.orderTime)}  ${DateFormat.Hm().format(widget.data.orderTime)}"),
                ],
              ),
            ),
            Flexible(
              child: Container(),
            ),
            _getWidget(widget.data.status),
          ],
        ),
      ),
    );
  }
  Widget _duplicateOrder(BuildContext context){
    return CustomButton.colored(color:ColorConstants.red, width: 190,height: 45,child:CustomText.white12px(TextConstants.cartDiplicateOrder),onClick: ()=>{
      Resources().cart.setCart(widget.data.cart.cart),
      Navigator.push( context,CartButtonRoute( builder: (context) => CartPage()),)
    });



  }
  bool used = false;


  Widget _getText(String orderStatus,
      {TextAlign align = TextAlign.center}) {
    switch (orderStatus) {
      case "N":
        return CustomText.gray12px(
          TextConstants.orderCall,
          align: align,
        );
        break;
      case "P":
        return CustomText.gray12px(TextConstants.orderDelivery, align: align);
        break;
      case "F":
        return CustomText.gray12px(TextConstants.orderDone, align: align);
        break;
      case "ON":
        return CustomText.gray12px(TextConstants.orderPay, align: align);
        break;
      default:
        return CustomText.gray12px(TextConstants.orderDone, align: align);
    }
  }

  Color _getColor(String orderStatus) {
    switch (orderStatus) {
      case  "N":
        return ColorConstants.orderCall;
        break;
      case "P":
        return ColorConstants.orderDelivery;
        break;
      case "F":
        return ColorConstants.orderDone;
        break;
      case "ON":
        return ColorConstants.orderPay;
        break;
      default:
        return ColorConstants.orderDone;
    }
  }

  Widget _getIcon(String orderStatus) {
    switch (orderStatus) {
      case "N":
        return AssetsConstants.iconOrderCall;
        break;
      case "P":
        return AssetsConstants.iconOrderDelivery;
        break;
      case "F":
        return AssetsConstants.iconOrderDone;
        break;
      case "ON":
        return AssetsConstants.iconOrderPay;
        break;
      default:
        return AssetsConstants.iconOrderDone;
    }
  }

  Widget _getWidget(String orderStatus) {
    return Container(
      width: 130,
      height: 999,
      decoration: BoxDecoration(
        color: _getColor(orderStatus),
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(0),
            right: Radius.circular(ParametersConstants.largeImageBorderRadius)),
      ),
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _getIcon(orderStatus),
          ),
          _getText(orderStatus)
        ],
      ),
    );
  }




}
