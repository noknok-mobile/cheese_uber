import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Drawers/LeftMenu.dart';
import 'package:flutter_cheez/Widgets/Forms/AddBonuses.dart';
import 'package:flutter_cheez/Widgets/Forms/CartBottomAppBar.dart';
import 'package:flutter_cheez/Widgets/Forms/CartGoods.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';

import 'NewOrderPage.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  final String title = TextConstants.cartHeader;
  final double bottomMenuHeight = 223;
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  bool showGoodsInCart = false;
  StreamSubscription subsctiprion;
  int _deliveryType = 1;

  @override
  void initState() {
    super.initState();

    showGoodsInCart = Resources().cart.getUniqueGoodsInCart() != 0;
    if (Resources().cart.getUniqueGoodsInCart() > 0)
      Resources().sendBasketData(Resources().cart);
    subsctiprion = eventBus.on<CartUpdated>().listen((CartUpdated data) {
      if (data.cart.getUniqueGoodsInCart() == 0) {
        setState(() => {showGoodsInCart = false});
      }
    });

    Resources().getSavedDeliveryType().then((value) {
      setState(() {
        _deliveryType = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subsctiprion.cancel();
    subsctiprion = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: ColorConstants.background,
        appBar: NextPageAppBar(
            height: ParametersConstants.appBarHeight,
            title: TextConstants.cartHeader),
        drawer: Drawer(child: LeftMenu()),
        //floatingActionButton: CartButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Center(
          child: FutureBuilder(
            future: Resources().getCart(),
            builder: (context, AsyncSnapshot<Map<int, double>> projectSnap) {
              if (projectSnap.hasError) {
                print('project snapshot data is: ${projectSnap.data}');
                return Container();
              }
              if (projectSnap.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }

              return Stack(
                children: <Widget>[
                  !showGoodsInCart
                      ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 300),
                            child:
                                CustomText.black18px(TextConstants.cartEmpty),
                          ))
                      : Container(),
                  !showGoodsInCart
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Image(image: AssetsConstants.emptyCart))
                      : Container(),
                  ListView.builder(
                    padding: EdgeInsets.only(
                        bottom: widget.bottomMenuHeight +
                            ParametersConstants.paddingInFerstListElemetn),
                    itemCount: projectSnap.data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                              height: index == 0
                                  ? ParametersConstants
                                      .paddingInFerstListElemetn
                                  : 0),
                          FutureBuilder(
                            future: Resources().getProduct(
                                projectSnap.data.keys.toList()[index]),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return CircularProgressIndicator();
                              }

                              return CartGoods(data: snapshot.data);
                            },
                          ),
                          index == projectSnap.data.length - 1
                              ? AddBonuses()
                              : Container(),
                          index == projectSnap.data.length - 1
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: CustomButton.colored(
                                    color: ColorConstants.red,
                                    enable: true,
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    height: 45,
                                    child: CustomText.white12px(
                                      TextConstants.cartClear.toUpperCase(),
                                    ),
                                    onClick: () => {Resources().clearCart()},
                                  ),
                                )
                              : Container(),
                        ],
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: showGoodsInCart ? widget.bottomMenuHeight : 0,
                      child: BottomAppBar(
                          shape: const CircularNotchedRectangle(),
                          child: CartBottomAppBar(
                            height: widget.bottomMenuHeight,
                            deliveryType: _deliveryType,
                            onBottomButtonClick: () => {
                              if (Resources().userProfile.id != null)
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewOrderPage()))
                                }
                              else
                                {Navigator.pushNamed(context, '/login')}
                            },
                          )),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
