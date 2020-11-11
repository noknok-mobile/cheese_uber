import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Drawers/LeftMenu.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';
import 'package:flutter_cheez/Widgets/Forms/Order.dart';

class OrdersPage extends StatelessWidget {
  final int openOrder;

  const OrdersPage({Key key, this.openOrder = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Tab> tabsTitles = List<Tab>();
    List<Widget> tabsContent = List<Widget>();
    var query = MediaQuery.of(context);

    tabsTitles.add(Tab(
      child: Container(
          width: query.size.width / 2 - 20,
          padding: const EdgeInsets.only(top: 25),
          alignment: Alignment.center,
          child: CustomText.black12px(TextConstants.activeOrders)),
    ));
    tabsTitles.add(Tab(
      child: Container(
          width: query.size.width / 2 - 20,
          padding: const EdgeInsets.only(top: 25),
          alignment: Alignment.center,
          child: CustomText.black12px(TextConstants.finishedOrders)),
    ));

    for (int i = 0; i < tabsTitles.length; i++) {
      tabsContent.add(AutoUpdatingWidget<OrderChanged>(
        child: (context, e) => FutureBuilder(
          future: i != 0
              ? Resources().getFinishedOrders()
              : Resources().getActiveOrders(),
          builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data.isEmpty) {
                return Stack(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 150),
                          child: Container(
                              width: 250,
                              child: CustomText.black24px(
                                TextConstants.ordersEmpty,
                                align: TextAlign.center,
                              )),
                        )),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: Image(image: AssetsConstants.emptyCart))
                  ],
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    // physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.fromLTRB(20, index == 0 ? 20 : 0, 20, 7),
                        child: Container(
                          child: Order(
                              data: snapshot.data[index],
                              opened: openOrder == snapshot.data[index].id),
                        ),
                      );
                    });
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
            return CircularProgressIndicator();
          },
        ),
      ));
    }

    // TODO: implement build
    return DefaultTabController(
        length: tabsContent.length,
        initialIndex: 0,
        child: Scaffold(
            drawer: Drawer(child: LeftMenu()),
            appBar: NextPageAppBar(
              height: ParametersConstants.appBarHeight,
              title: TextConstants.orderHeader,
              bottom: TabBar(
                labelColor: ColorConstants.darkGray,
                unselectedLabelColor: ColorConstants.gray,
                indicatorColor: ColorConstants.red,
                indicatorWeight: 3,
                labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                isScrollable: true,
                tabs: tabsTitles,
              ),
            ),
            body: TabBarView(
              children: tabsContent,
            )));
  }
}
