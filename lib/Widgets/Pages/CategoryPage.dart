import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Drawers/LeftMenu.dart';
import 'package:flutter_cheez/Widgets/Drawers/MySnackBar.dart';
import 'package:flutter_cheez/Widgets/Forms/DiscountList.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/HomePageAppBar.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';
import '../../main.dart';
import 'GoodsPage.dart';
import 'OrdersPage.dart';

class CategoryPage extends StatefulWidget {
  String title = "";
  final int parentCategoryID;
  CategoryPage({Key key, this.parentCategoryID = 0}) : super(key: key) {
    if (parentCategoryID == 0)
      title = TextConstants.categoryHeader;
    else
      title = Resources().getCategoryById(parentCategoryID).title;
  }
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<Notification> notifications = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamSubscription<OrderChanged> subscription;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    if (Resources().userProfile.id != null) {
      _firebaseMessaging
          .subscribeToTopic(Resources().userProfile.email.replaceAll("@", '.'));
    }

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> notification) async {
      eventBus.fire(OrderChanged(notification));
    }, onLaunch: (Map<String, dynamic> notification) async {
      eventBus.fire(OrderChanged(notification));
    }, onResume: (Map<String, dynamic> notification) async {
      eventBus.fire(OrderChanged(notification));
    });

    if (subscription != null) {
      subscription.cancel();
      subscription = null;
    }
    subscription = eventBus.on<OrderChanged>().listen((event) {
      setState(() => Scaffold.of(context).showSnackBar(MySnackBar.build(
          context: scaffoldKey.currentContext,
          message: event.notification["notification"]["body"],
          type: SnackBatMessageType.info,
          onTap: () {
            print(event.notification);
            Navigator.push(
                scaffoldKey.currentContext,
                MaterialPageRoute(
                    builder: (context) => OrdersPage(
                          openOrder:
                              int.parse(event.notification["data"]["orderId"]),
                        )));
          })));
    });
  }

  @override
  void dispose() {
    print("dispoce");
    super.dispose();
    subscription.cancel();
    subscription = null;
  }

  @override
  Widget build(BuildContext context) {
    var data = Resources().getCategoryWithParent(widget.parentCategoryID);
    return Scaffold(
        key: scaffoldKey,
        appBar: widget.parentCategoryID == 0
            ? HomePageAppBar(
                height: ParametersConstants.appBarHeight,
                title: widget.title,
              )
            : NextPageAppBar(
                height: ParametersConstants.appBarHeight,
                title: widget.title,
              ),
        drawer: Drawer(child: LeftMenu()),
        floatingActionButton: CartButton(),
        body: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(children: <Widget>[
                SizedBox(
                  height: index == 0
                      ? ParametersConstants.paddingInFerstListElemetn
                      : 0,
                ),
                widget.parentCategoryID == 0 && index == 0
                    ? DiscountList(
                        height: 84,
                      )
                    : Container(),
                Container(
                    margin: ParametersConstants.goodsContainersMargin,
                    child: CachedImage.imageForCategory(
                        url: data[index].imageUrl,
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          onPressed: () {
                            var x = Resources()
                                .getCategoryWithParent(data[index].id);

                            if (x.length == 0) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return GoodsPage(
                                    categoryId: data[index].id, data: data);
                              }));
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CategoryPage(
                                    parentCategoryID: data[index].id);
                              }));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    ParametersConstants.largeImageBorderRadius),
                                gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    Colors.grey.withOpacity(0.0),
                                    Colors.black.withOpacity(0.5),
                                  ],
                                  stops: [
                                    0.0,
                                    1.0
                                  ]
                                )),
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Text(
                                data[index].title,
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                          ),
                        ))),
                SizedBox(
                  height: index == data.length - 1
                      ? ParametersConstants.paddingInFerstListElemetn
                      : 0,
                ),
              ]);
            }));
  }
}
