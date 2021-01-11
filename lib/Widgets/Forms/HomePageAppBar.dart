import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Pages/SearchPage.dart';
import 'package:flutter_cheez/Widgets/Pages/SelectShop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  String deliveryAddress;

  HomePageAppBar({Key key, @required this.height, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: ColorConstants.mainAppColor,
            boxShadow: [ParametersConstants.shadowDecoration]),
        child: SafeArea(
            child: Column(children: [
          Container(
            height: height,
            decoration: BoxDecoration(color: ColorConstants.mainAppColor),
            child: Row(children: [
              IconButton(
                icon: IconConstants.menu,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              IconButton(
                icon: IconConstants.search,
                onPressed: () {
                  Navigator.of(context).push(_createRoute());
                },
              ),

              /*
                IconButton(
                  icon: Icon(Icons.verified_user),
                  onPressed: () => null,
                ),*/
            ]),
          ),
          Container(height: 1, color: Colors.grey[200]),
          Container(
              child: GestureDetector(
            child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(color: ColorConstants.mainAppColor),
                child: FutureBuilder(
                    future: Resources().getCurrentDeliveryAddress(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done)
                        return Center(child: CircularProgressIndicator());

                      deliveryAddress = snapshot.data;

                      return Text(deliveryAddress,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.normal));
                    })),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SelectShop(selectedAddress: deliveryAddress))),
          ))
        ])));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, -1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + 60);
}
