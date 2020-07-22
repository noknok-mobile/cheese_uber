import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Buttons/CustomCheckBox.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:math' as math;

class SelectShop extends StatefulWidget {
  final CityInfo selectedCity;
  final double _itemHeight = 40.0;
  int shopId = 0;
  SelectShop({@required this.selectedCity});

  @override
  State<StatefulWidget> createState() => _SelectShopState();
}

Point currentLocation;

class _SelectShopState extends State<SelectShop> {
  YandexMapController controller;

  @override
  Widget build(BuildContext context) {
    var shops = Resources().getAllShops;
    var shopsInCity = shops.where((x) => x.city == widget.selectedCity.id);
    var query = MediaQuery.of(context);
    var menuHeight = math.min(shopsInCity.length * widget._itemHeight + 75 + 90,
        query.size.height / 2);
    if(widget.shopId == 0)
      widget.shopId = shopsInCity.first.shopId;
    //Resources().selectShop(shopsInCity.first.shopId);
    // TODO: implement build
    return Scaffold(

      body: YandexMap(
        onMapCreated: (YandexMapController yandexMapController) async {
          controller = yandexMapController;
          List<ShopInfo> shops = Resources().getAllShops;

          shops.forEach((x) async => await controller.addPlacemark(Placemark(

                point: Point(
                    longitude: x.mapPoint.longitude,
                    latitude: x.mapPoint.latitude),
                opacity: 1,
                scale: 2,
                iconName: 'lib/assets/icons/map_pointer_shop.png',

                onTap: (double latitude, double longitude) =>{
                widget.shopId = x.shopId,
                   setState(()=>{}),}
                // Resources().selectShop(x.shopId),
                // log(x.shopId)
                // },
              )));
          await controller.addPlacemark(Placemark(
            point: Point(
                longitude: Resources().geolocation.longitude,
                latitude: Resources().geolocation.latitude),
            opacity: 1,
            scale: 2,
            iconName: 'lib/assets/icons/address.png',
          ));
          // currentLocation = await controller.getTargetPoint();
          controller.move(
              point: Point(
                  longitude: Resources().geolocation.longitude,
                  latitude: Resources().geolocation.latitude));
          controller.zoomIn();
        },
      ),
      bottomNavigationBar: Container(
       // padding: EdgeInsets.only(bottom: 20),
        // margin: EdgeInsets.all(20),
        height: menuHeight,
        decoration: ParametersConstants.BoxShadowDecoration,
        //  height: shopsInCity.length * widget._itemHeight + 75 + 45,
        child: Column(
         // direction: Axis.vertical,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomText.black24px(TextConstants.selectCity),
            ),
            Container(
              height: 1,
              color: ColorConstants.gray,
            ),
            Container(
              height: menuHeight - 160,
              child: ListView.separated(
                  itemBuilder: (buildContext, index) => Container(
                      height: widget._itemHeight,
                      child:

                         CustomCheckBox(
                            enabledWidget: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    CustomText.black16px(
                                        shopsInCity.elementAt(index).address),
                                    Expanded(child: Container()),
                                    AssetsConstants.iconCheckBox,
                                  ],
                                )),
                            disabledWidget: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    CustomText.black16px(
                                        shopsInCity.elementAt(index).address),
                                    Expanded(child: Container()),
                                  ],
                                )),
                            value: widget.shopId ==
                                shopsInCity.elementAt(index).shopId,
                            onChanged: (x) => {
                              print("shopsInCity.elementAt(index).shopId "+shopsInCity.elementAt(index).shopId.toString()),

                              setState(()=>{ widget.shopId =shopsInCity.elementAt(index).shopId,}),
                                  /*Resources().selectShop(
                                      shopsInCity.elementAt(index).shopId),*/
                                  controller.move(
                                      animation: MapAnimation(),
                                      point: Point(
                                          longitude: shopsInCity
                                              .elementAt(index)
                                              .mapPoint
                                              .longitude,
                                          latitude: shopsInCity
                                              .elementAt(index)
                                              .mapPoint
                                              .latitude))
                                })
                      ),
                  separatorBuilder: (buildContext, index) => Container(
                        height: 1,
                        color: ColorConstants.gray,
                      ),
                  itemCount: shopsInCity.length),
            ),
            Container(
              height: 1,
              color: ColorConstants.gray,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomButton.colored(
                      expanded: true,
                      color: ColorConstants.red,
                      height: 40,
                      child: CustomText.white12px(TextConstants.btnNext.toUpperCase()),
                      onClick: () => {
                            Resources().selectShop(widget.shopId),
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryPage()), (x) {
                              return false;
                            })
                          })),
            ),
          ],
        ),
      ),

      /*    GoogleMap (

        mapType: MapType.normal,
        initialCameraPosition: widget.kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          widget.controller.complete(controller);
        },
      ),*/
    );
  }
}
