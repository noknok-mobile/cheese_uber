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
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:math' as math;

import '../../Resources/Models.dart';
import '../../Resources/Resources.dart';
import '../../Resources/Resources.dart';
import '../../Resources/Resources.dart';
import '../../Resources/Resources.dart';
import '../../Resources/Resources.dart';
import '../../Utils/Geolocation.dart';
import '../../Utils/Geolocation.dart';

class SelectShop extends StatefulWidget {
  final CityInfo selectedCity;
  final double _itemHeight = 40.0;
  int shopId = 0;
  Address deliveryAddress;
  SelectShop({@required this.selectedCity});

  @override
  State<StatefulWidget> createState() => _SelectShopState();
}

class _SelectShopState extends State<SelectShop> {
  YandexMapController controller;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Address> getAddressFromCoordinates(Point point) async {
    var addresses = await Geolocation()
        .findAddressesFromCoordinates(point.latitude, point.longitude);

    return addresses[0];
  }

  @override
  Widget build(BuildContext context) {
    var shops = Resources().getAllShops;
    var shopsInCity = shops.where((x) => x.city == widget.selectedCity.id);
    var query = MediaQuery.of(context);
    var menuHeight = math.min(
        shopsInCity.length * widget._itemHeight + 75 + 105,
        query.size.height / 2);
    if (widget.shopId == 0) widget.shopId = shopsInCity.first.shopId;
    //Resources().selectShop(shopsInCity.first.shopId);

    var addressTextField = TextEditingController();

    Point selectedLocation;
    Placemark currentPlacemark;

    return Scaffold(
      body: YandexMap(
        onMapTap: (Point point) async {
          selectedLocation = point;

          final SharedPreferences prefs = await _prefs;
          prefs.setDouble("currentLong", point.longitude);
          prefs.setDouble("currentLat", point.latitude);

          if (controller.placemarks.contains(currentPlacemark)) {
            controller.removePlacemark(currentPlacemark);
          }

          currentPlacemark = Placemark(
              point: Point(
                  longitude: selectedLocation.longitude,
                  latitude: selectedLocation.latitude),
              opacity: 1,
              scale: 2,
              iconName: 'lib/assets/icons/address.png',
              iconAnchor: Point(latitude: 0.5, longitude: 1.0));

          controller.addPlacemark(currentPlacemark);

          Address address = await getAddressFromCoordinates(selectedLocation);

          addressTextField.text = address.locality +
              ", " +
              address.thoroughfare +
              ", " +
              address.featureName;

          widget.shopId =
              (await Resources().getNearestShopByLocation(selectedLocation))
                  .shopId;

          widget.deliveryAddress = address;
        },
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
              iconAnchor: Point(latitude: 0.5, longitude: 1.0)
              // onTap: (Point point) => {
              //       widget.shopId = x.shopId,
              //       setState(() => {}),
              //     }
              // Resources().selectShop(x.shopId),
              // log(x.shopId)
              // },
              )));

          final SharedPreferences prefs = await _prefs;
          var currentLong = prefs.getDouble("currentLong");
          var currentLat = prefs.getDouble("currentLat");
          Point point;
          if (currentLong != null && currentLat != null) {
            point = Point(longitude: currentLong, latitude: currentLat);
          } else {
            point = Point(
                longitude: Resources().geolocation.longitude,
                latitude: Resources().geolocation.latitude);
          }

          Address address = await getAddressFromCoordinates(point);
          widget.deliveryAddress = address;

          addressTextField.text = address.locality +
              ", " +
              address.thoroughfare +
              ", " +
              address.featureName;

          currentPlacemark = Placemark(
              point: point,
              opacity: 1,
              scale: 2,
              iconName: 'lib/assets/icons/address.png',
              iconAnchor: Point(latitude: 0.5, longitude: 1.0));

          await controller.addPlacemark(currentPlacemark);
          // currentLocation = await controller.getTargetPoint();
          controller.move(point: point);
          controller.zoomIn();

          var addressList =
              await Geolocation().findAddressesFromQuery("Ленина, 20");

          point = Point(
              latitude: addressList[0].coordinates.latitude,
              longitude: addressList[0].coordinates.longitude);

          print("addressList --- " + addressList.length.toString());
        },
      ),
      bottomNavigationBar: Container(
        // padding: EdgeInsets.only(bottom: 20),
        // margin: EdgeInsets.all(20),
        height: menuHeight - 150,
        decoration: ParametersConstants.BoxShadowDecoration,
        //  height: shopsInCity.length * widget._itemHeight + 75 + 45,
        child: Column(
          // direction: Axis.vertical,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomText.black24px(TextConstants.selectAddressDelivery),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0),
                child: TextField(
                    // readOnly: true,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    controller: addressTextField,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: new OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(5.0))))),
              ),
            ),
            // Container(
            //   height: menuHeight - 160,
            //   child: ListView.separated(
            //       itemBuilder: (buildContext, index) => Container(
            //           height: widget._itemHeight,
            //           child: CustomCheckBox(
            //               enabledWidget: Container(
            //                   padding: EdgeInsets.all(10),
            //                   alignment: Alignment.centerLeft,
            //                   child: Row(
            //                     children: <Widget>[
            //                       CustomText.black16px(
            //                           shopsInCity.elementAt(index).address),
            //                       Expanded(child: Container()),
            //                       AssetsConstants.iconCheckBox,
            //                     ],
            //                   )),
            //               disabledWidget: Container(
            //                   padding: EdgeInsets.all(10),
            //                   alignment: Alignment.centerLeft,
            //                   child: Row(
            //                     children: <Widget>[
            //                       CustomText.black16px(
            //                           shopsInCity.elementAt(index).address),
            //                       Expanded(child: Container()),
            //                     ],
            //                   )),
            //               value: widget.shopId ==
            //                   shopsInCity.elementAt(index).shopId,
            //               onChanged: (x) => {
            //                     print("shopsInCity.elementAt(index).shopId " +
            //                         shopsInCity
            //                             .elementAt(index)
            //                             .shopId
            //                             .toString()),
            //                     setState(() => {
            //                           widget.shopId =
            //                               shopsInCity.elementAt(index).shopId,
            //                         }),
            //                     /*Resources().selectShop(
            //                           shopsInCity.elementAt(index).shopId),*/
            //                     controller.move(
            //                         animation: MapAnimation(),
            //                         point: Point(
            //                             longitude: shopsInCity
            //                                 .elementAt(index)
            //                                 .mapPoint
            //                                 .longitude,
            //                             latitude: shopsInCity
            //                                 .elementAt(index)
            //                                 .mapPoint
            //                                 .latitude))
            //                   })),
            //       separatorBuilder: (buildContext, index) => Container(
            //             height: 1,
            //             color: ColorConstants.gray,
            //           ),
            //       itemCount: shopsInCity.length),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomButton.colored(
                      expanded: true,
                      color: ColorConstants.red,
                      height: 40,
                      child: CustomText.white12px(
                          TextConstants.btnNext.toUpperCase()),
                      onClick: () => {
                            Resources().editAddrese(UserAddress(
                                city: widget.selectedCity.name,
                                addres: widget.deliveryAddress.thoroughfare +
                                    ", " +
                                    widget.deliveryAddress.featureName)),
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
