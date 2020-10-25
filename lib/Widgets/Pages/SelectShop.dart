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
import 'package:flutter_cheez/Widgets/Pages/SelectAddres.dart';
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
  CityInfo selectedCity;
  final double _itemHeight = 40.0;
  int shopId = 0;
  Address deliveryAddress;
  SelectShop();

  @override
  _SelectShopState createState() => _SelectShopState();
}

class _SelectShopState extends State<SelectShop> {
  YandexMapController controller;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var addressTextField = TextEditingController();

  Point selectedLocation;
  Placemark currentPlacemark;

  bool _selectShopButtonEnabled = true;

  Future<Address> getAddressFromCoordinates(Point point) async {
    var addresses = await Geolocation()
        .findAddressesFromCoordinates(point.latitude, point.longitude);

    return addresses[0];
  }

  void selectShop(Point location) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setDouble("currentLong", location.longitude);
    prefs.setDouble("currentLat", location.latitude);

    if (currentPlacemark != null) {
      controller.removePlacemark(currentPlacemark);
    }

    currentPlacemark = Placemark(
        point:
            Point(longitude: location.longitude, latitude: location.latitude),
        opacity: 1,
        scale: 2,
        iconName: 'lib/assets/icons/address.png',
        iconAnchor: Point(latitude: 0.5, longitude: 1.0));

    controller.addPlacemark(currentPlacemark);

    Address address = await getAddressFromCoordinates(location);

    addressTextField.text = address.locality + ", " + address.featureName;

    widget.shopId =
        (await Resources().getNearestShopByLocation(location)).shopId;

    widget.deliveryAddress = address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: FutureBuilder(
          future: Resources().loadShops(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done ||
                snapshot.data == null) {
              return CircularProgressIndicator();
            }

            return YandexMap(
              onMapTap: (Point point) async {
                selectedLocation = point;

                selectShop(selectedLocation);
              },
              onMapCreated: (YandexMapController yandexMapController) async {
                controller = yandexMapController;
                List<ShopInfo> shops = Resources().getAllShops;

                shops.forEach((x) async => await controller.addPlacemark(
                    Placemark(
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

                if (currentLong != null && currentLat != null) {
                  selectedLocation =
                      Point(longitude: currentLong, latitude: currentLat);
                } else {
                  if (Resources().geolocation.latitude != null ||
                      Resources().geolocation.longitude != null) {
                    selectedLocation = Point(
                        longitude: Resources().geolocation.longitude,
                        latitude: Resources().geolocation.latitude);
                  } else {
                    selectedLocation = shops.first.mapPoint;
                  }
                }

                selectShop(selectedLocation);

                controller.move(point: selectedLocation);
                controller.zoomIn();
              },
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 225,
            decoration: ParametersConstants.BoxShadowDecoration,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      CustomText.black20px(TextConstants.selectAddressDelivery),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10.0),
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      controller: addressTextField,
                      cursorColor: Colors.red,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: new OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0)))),
                      onTap: () {
                        setState(() {
                          _selectShopButtonEnabled = false;
                        });
                      },
                      onSubmitted: (value) async {
                        setState(() {
                          _selectShopButtonEnabled = true;
                        });

                        var addressList = await Geolocation()
                            .findAddressesFromQuery(addressTextField.text);

                        currentLocation = Point(
                            latitude: addressList[0].coordinates.latitude,
                            longitude: addressList[0].coordinates.longitude);

                        selectShop(currentLocation);

                        controller.move(point: currentLocation);
                        controller.zoomIn();
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CustomButton.colored(
                          enable: _selectShopButtonEnabled,
                          expanded: true,
                          color: ColorConstants.red,
                          height: 40,
                          child: CustomText.white12px(
                              TextConstants.btnNext.toUpperCase()),
                          onClick: () => {
                                Resources().editAddrese(UserAddress(
                                    city: Resources()
                                        .getCityWithId(Resources()
                                            .getShopWithId(widget.shopId)
                                            .city)
                                        .name,
                                    addres: widget
                                            .deliveryAddress.thoroughfare +
                                        ", " +
                                        widget.deliveryAddress.featureName)),
                                Resources().selectShop(widget.shopId),
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryPage()),
                                    (x) {
                                  return false;
                                })
                              })),
                ),
              ],
            ),
          ),
        )
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
