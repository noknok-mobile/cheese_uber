import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/NetworkUtil.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Drawers/LeftMenu.dart';
import 'package:flutter_cheez/Widgets/Drawers/MySnackBar.dart';
import 'package:flutter_cheez/Widgets/Forms/DiscountList.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/HomePageAppBar.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';
import '../../Resources/Resources.dart';
import '../../Resources/Resources.dart';
import '../../Resources/Resources.dart';
import '../../Resources/Resources.dart';
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

    _firebaseMessaging.getToken().then((token) {
      print("FirebaseMessaging token: $token");
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
    Future loadData(int parentCategory) {
      if (parentCategory == 0 && Resources().categories.length == 0) {
        return Future.wait(
            [Resources().loadCategories(), Resources().loadProducts()]);
      }
      if (Resources().categories.length == 0) {
        return Resources().loadCategories();
      }

      return Resources().getCategory();
    }

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
        body: FutureBuilder(
          future: loadData(widget.parentCategoryID),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print('project snapshot data is: ${snapshot.data}');
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }
            var data =
                Resources().getCategoryWithParent(widget.parentCategoryID);

            return ListView.builder(
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
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                ParametersConstants.largeImageBorderRadius)),
                        child: GestureDetector(
                            onTap: () {
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
                            child: Stack(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                              child: CachedNetworkImage(
                                            height: 100.0,
                                            imageUrl:
                                                data[index].imageUrl.isEmpty
                                                    ? NetworkUtil.defauilPicture
                                                    : data[index].imageUrl,
                                            placeholder: (context, url) =>
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: ColorConstants
                                                          .mainAppColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                    ),
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator())),
                                          )),
                                        ),
                                        Expanded(
                                            flex: 6,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                child: Text(
                                                  data[index].title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 20),
                                                )))
                                      ],
                                    )),
                                if (widget.parentCategoryID != 0)
                                  Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFF3C611),
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child: Center(
                                            child: Text(
                                                Resources()
                                                    .getGoodsInCategoryCount(
                                                        data[index].id)
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal))),
                                      ))
                              ],
                            ))),
                    SizedBox(
                      height: index == data.length - 1
                          ? ParametersConstants.paddingInFerstListElemetn
                          : 0,
                    ),
                  ]);
                });
          },
        ));
  }
}
