import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/Logo.dart';
import 'package:flutter_cheez/Widgets/Pages/InformationPage.dart';
import 'package:flutter_svg/svg.dart';

class LeftMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Container(
      color: ColorConstants.mainAppColor,
      child: Flex(
        direction: Axis.vertical,
        // Important: Remove any padding from the ListView.

        // padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height:300,
            padding:  const EdgeInsets.all( 0),
            child: DrawerHeader(

              padding: const EdgeInsets.all( 0),
              child:  Stack(
                children: <Widget>[
                  Container(
                      height:100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                          fit: BoxFit.fitWidth,
                            alignment: FractionalOffset.topCenter,
                            image:AssetsConstants.drawerBackground,
                          ))
                    ),
                  Logo(height: 200,),
                ],
              ),
              decoration: BoxDecoration(
                  // color: Colors.blue,
                  ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: CustomText.black24px(Resources().userProfile.username),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
            child: GestureDetector(
                child: CustomText.red14pxUnderline(TextConstants.showProfile),
                onTap: () => {
                      //  Navigator.of(context).pop(PageRoute());
                    }),
          ),
          Divider(
            height: 1,
            color: ColorConstants.darkGray,
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            leading: AssetsConstants.iconCheese,
            title: CustomText.black20px(TextConstants.categoryHeader),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(
            height: 1,
            color: ColorConstants.darkGray,
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            leading: AssetsConstants.iconShoppingBasket,
            title: CustomText.black20px(TextConstants.cartHeader),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(
            height: 1,
            color: ColorConstants.darkGray,
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            leading: AssetsConstants.iconShoppingBag,
            title: CustomText.black20px(TextConstants.orderHeader),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(
            height: 1,
            color: ColorConstants.darkGray,
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            leading: AssetsConstants.iconRoundInfoBtn,
            title: CustomText.black20px(TextConstants.infoHeader),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute( builder: (context) => InformationPage()));
              // Update the state of the app.
              // ...
            },
          ),
          Divider(
            height: 1,
            color: ColorConstants.darkGray,
          ),
          Expanded(
            child: Container(),
          ),
          Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              child: Row(
                children: <Widget>[
                  CustomText.black16px(TextConstants.cityTitle),
                  CustomText.red14pxUnderline(
                      Resources().getShopWithId(Resources().userProfile.selectedShop).city),
                ],
              )),
          Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              child: Row(
                children: <Widget>[
                  CustomText.black16px(TextConstants.shopTitle),
                  CustomText.red14pxUnderline(
                      Resources().getShopWithId(Resources().userProfile.selectedShop).address),
                ],
              )),
        ],
      ),
    );
  }
}
