import 'dart:async';

import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'InformationRow.dart';

class Order extends StatefulWidget implements PreferredSizeWidget {
  final OrderData data;
  final bool opened;
  const Order({Key key, this.data, this.opened = false}) : super(key: key);

  Widget _getDetailInfo(OrderData _data) {}

  Widget detailBuilder(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                alignment: Alignment.centerRight,
                // padding: const EdgeInsets.only(right: 10),
                onPressed: () => {Navigator.pop(context)},
                icon: IconConstants.arrowDownBlack,
              ),
              Expanded(
                  child: CustomText.black24px(
                      "${TextConstants.orderNumber} ${data.id.toString()}")),
              Container(
                width: 130,
                height: 25,
                decoration: BoxDecoration(
                  color: _getColor(data.status),
                  borderRadius: BorderRadius.all(Radius.circular(
                      ParametersConstants.largeImageBorderRadius)),
                ),
                alignment: Alignment.center,
                child: _getText(data.status),
              )
            ],
          ),
          Container(
            //height:240,
            child: Column(
              //  shrinkWrap: true,

              children: <Widget>[
                Container(
                  height: 20,
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.cart.cart.keys.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: Resources()
                            .getProduct(data.cart.cart.keys.elementAt(index)),
                        builder: (context, AsyncSnapshot<GoodsData> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(child: CircularProgressIndicator());
                          }

                          return FlatButton(
                            onPressed: () => {
                              Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (context) {
                                return DetailGoods(
                                  goodsData: snapshot.data,
                                );
                              }))
                            },
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CustomText.black16px(
                                      snapshot.data.name,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText.black16px(
                                        "${data.cart.cart[data.cart.cart.keys.elementAt(index)]} x "
                                        "${data.cart.savedCartPrice.values.elementAt(index)}${TextConstants.pricePostfix}"),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CustomText.black16px(
                                        "${data.cart.savedCartPrice.values.elementAt(index) * data.cart.cart[data.cart.cart.keys.elementAt(index)]}${TextConstants.pricePostfix}",
                                        maxLines: 1),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                InformationRow(
                  icon: AssetsConstants.iconInfoPay,
                  label: TextConstants.payMethod,
                  text: data.payType == PayType.cash
                      ? TextConstants.payMethodCash
                      : TextConstants.payMethodOnline,
                ),
                Container(
                  height: 10,
                ),
                InformationRow(
                  icon: AssetsConstants.iconInfoDelivery,
                  label: TextConstants.delivery,
                  text: data.deliveryType == DeliveryType.courier
                      ? TextConstants.deliveryMethodCourier
                      : TextConstants.deliveryMethodPickup,
                  posfix: data.deliveryPrice.toStringAsFixed(1) +
                      TextConstants.pricePostfix,
                ),
                Container(
                  height: 10,
                ),
                InformationRow(
                  icon: AssetsConstants.iconInfoTime,
                  label: TextConstants.deliveryTime,
                  text:
                      "${DateFormat.d().format(data.orderTime)}.${DateFormat.M().format(data.orderTime)}.${DateFormat.y().format(data.orderTime)}  ${DateFormat.Hm().format(data.orderTime)}",
                ),
                Container(
                  height: 10,
                ),
                InformationRow(
                  icon: AssetsConstants.iconInfoUser,
                  label: TextConstants.contactName,
                  text: data.userAddress.username,
                ),
                Container(
                  height: 10,
                ),
                InformationRow(
                  icon: AssetsConstants.iconInfoAdres,
                  label: TextConstants.adres,
                  text: data.userAddress.addres,
                ),
                Container(
                  height: 20,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(bottom: 10),
            color: ColorConstants.darkGray,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: PriceRow(
                text: data.price,
              )),
              data.status == "ON"
                  ? _payOrder(context)
                  : _duplicateOrder(context)
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget _duplicateOrder(BuildContext context) {
    return CustomButton.colored(
        color: ColorConstants.red,
        width: 190,
        height: 45,
        child: CustomText.white12px(
            TextConstants.cartDiplicateOrder.toUpperCase()),
        onClick: () => {
              Resources().saveCart(data.cart),
              Resources()
                  .cart
                  .setCart2(data.cart.cart, data.cart.savedCartPrice),
              Navigator.push(
                context,
                CartButtonRoute(builder: (context) => CartPage()),
              )
            });
  }

  Widget _payOrder(BuildContext context) {
    return CustomButton.colored(
      color: ColorConstants.red,
      width: 190,
      height: 45,
      child: CustomText.white12px(TextConstants.orderMakePay.toUpperCase()),
      onClick: () async {
        FirebaseAnalytics().logEvent(name: 'purchase');
        AppmetricaSdk().reportEvent(name: 'purchase');
        String href = await Resources().getPayment(data.id);

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             WebPage(title: TextConstants.orderSberbankPay, url: href)));

        // launch(href);
        FlutterWebBrowser.openWebPage(
          url: href,
          customTabsOptions: CustomTabsOptions(
            addDefaultShareMenuItem: false,
            instantAppsEnabled: true,
            showTitle: false,
            urlBarHidingEnabled: false,
          ),
        );
      },
    );
  }

  Widget _getText(String orderStatus, {TextAlign align = TextAlign.center}) {
    switch (orderStatus) {
      case "N":
        return CustomText.gray12px(
          TextConstants.orderCall.toUpperCase(),
          align: align,
        );
        break;
      case "P":
        return CustomText.gray12px(TextConstants.orderDelivery.toUpperCase(),
            align: align);
        break;
      case "F":
        return CustomText.gray12px(TextConstants.orderDone.toUpperCase(),
            align: align);
        break;
      case "ON":
        return CustomText.gray12px(TextConstants.orderPay.toUpperCase(),
            align: align);
        break;
      default:
        return CustomText.gray12px(TextConstants.orderDone.toUpperCase(),
            align: align);
    }
  }

  Color _getColor(String orderStatus) {
    switch (orderStatus) {
      case "N":
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

  Widget getWidget(String orderStatus) {
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

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;

  @override
  State<StatefulWidget> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  void initState() {
    super.initState();
  }

  void _showModalBar() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(ParametersConstants.largeImageBorderRadius)),
        ),
        builder: widget.detailBuilder);
  }

  var timer;
  @override
  Widget build(BuildContext context) {
    /* print("opened "+widget.opened.toString());
    if(widget.opened) setState(() { showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(

          borderRadius:BorderRadius.vertical(top:Radius.circular(ParametersConstants.largeImageBorderRadius) ),),
        builder:widget.detailBuilder);})  ;*/
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    print("opened " + widget.opened.toString());
    if (widget.opened && timer == null) {
      timer = new Timer(
          Duration(milliseconds: 200),
          () => setState(() {
                print("Timer tick showModalBottomSheet");

                _showModalBar();
              }));
    }

    return Center(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: ColorConstants.mainAppColor,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(ParametersConstants.largeImageBorderRadius)),
        ),
        child: FlatButton(
          padding: const EdgeInsets.all(0),
          onPressed: () => {_showModalBar()},
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
                          "${widget.data.price.toString()} ${TextConstants.pricePostfix}"),
                    ),
                    CustomText.darkGray14px(
                        "${DateFormat.d().format(widget.data.orderTime)}.${DateFormat.M().format(widget.data.orderTime)}.${DateFormat.y().format(widget.data.orderTime)}  ${DateFormat.Hm().format(widget.data.orderTime)}"),
                  ],
                ),
              ),
              Flexible(
                child: Container(),
              ),
              widget.getWidget(widget.data.status),
            ],
          ),
        ),
      ),
    );
  }
}
