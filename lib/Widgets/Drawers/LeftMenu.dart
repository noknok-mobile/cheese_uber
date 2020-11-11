import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/Logo.dart';
import 'package:flutter_cheez/Widgets/Pages/CartPage.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';
import 'package:flutter_cheez/Widgets/Pages/ChangeCity.dart';
import 'package:flutter_cheez/Widgets/Pages/InformationPage.dart';
import 'package:flutter_cheez/Widgets/Pages/LoginPage.dart';
import 'package:flutter_cheez/Widgets/Pages/OrdersPage.dart';
import 'package:flutter_cheez/Widgets/Pages/SelectShop.dart';
import 'package:flutter_cheez/Widgets/Pages/UserInfo.dart';
import 'package:flutter_svg/svg.dart';

class LeftMenu extends StatelessWidget {
  Widget _content(BuildContext context, bool useExpand) {
    double height = MediaQuery.of(context).size.height / 3;
    print("height " + height.toString());
    return Column(
      // direction: Axis.vertical,
      // Important: Remove any padding from the ListView.

      // padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: height,
          padding: const EdgeInsets.all(0),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                    height: height / 2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.topCenter,
                      image: AssetsConstants.drawerBackground,
                    ))),
                Logo(
                  height: height / 1.5,
                ),
              ],
            ),
          ),
        ),

        if (Resources().userProfile.id == null)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
            child: GestureDetector(
                child: CustomText.red14pxUnderline(
                    TextConstants.login + " / " + TextConstants.register),
                onTap: () => {
                      Navigator.pushNamed(context, '/login',
                          arguments: LoginPageArguments('/category'))
                    }),
          ),

        if (Resources().userProfile.id != null)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: CustomText.black24px(Resources().userProfile.username),
          ),
        if (Resources().userProfile.id != null)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
            child: GestureDetector(
                child: CustomText.red14pxUnderline(TextConstants.showProfile),
                onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UserInfo()))
                    }),
          ),

        Container(
          height: 1,
          color: ColorConstants.gray,
        ),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
          leading: AssetsConstants.iconCheese,
          title: Align(
              alignment: Alignment(-1.3, 0),
              child: CustomText.black20px(TextConstants.categoryHeader)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoryPage()));
          },
        ),
        Container(
          height: 1,
          color: ColorConstants.gray,
        ),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
          leading: AssetsConstants.iconShoppingBasket,
          title: Align(
              alignment: Alignment(-1.3, 0),
              child: CustomText.black20px(TextConstants.cartHeader)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartPage()));
          },
        ),
        Container(
          height: 1,
          color: ColorConstants.gray,
        ),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
          leading: AssetsConstants.iconShoppingBag,
          title: Align(
              alignment: Alignment(-1.3, 0),
              child: CustomText.black20px(TextConstants.orderHeader)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OrdersPage()));
          },
        ),
        Container(
          height: 1,
          color: ColorConstants.gray,
        ),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
          leading: AssetsConstants.iconRoundInfoBtn,
          title: Align(
              alignment: Alignment(-1.3, 0),
              child: CustomText.black20px(TextConstants.infoHeader)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => InformationPage()));
            // Update the state of the app.
            // ...
          },
        ),
        Container(
          height: 1,
          color: ColorConstants.gray,
        ),
        !useExpand
            ? Container()
            : Expanded(
                child: Container(),
              ),
        Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CustomText.black16px(TextConstants.cityTitle),
                  CustomText.red14pxUnderline(
                    Resources()
                        .getCityWithId(Resources()
                            .getShopWithId(Resources().userProfile.selectedShop)
                            .city)
                        .name,
                    align: TextAlign.left,
                  ),
                ],
              ),
            )),
        Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectShop())),
              child: Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: Axis.horizontal,
                children: <Widget>[
                  CustomText.black16px(TextConstants.shopTitle),
                  Flexible(
                    child: CustomText.red14pxUnderline(Resources()
                        .getShopWithId(Resources().userProfile.selectedShop)
                        .address),
                  ),
                ],
              ),
            )),
        Container(
          height: 25,
        )
        // Expanded(child: Container(),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool useExpand = MediaQuery.of(context).size.height / 3 > 200;
    return Container(
        color: ColorConstants.mainAppColor,
        child: useExpand
            ? _content(context, useExpand)
            : SingleChildScrollView(child: _content(context, useExpand)));
  }
}
