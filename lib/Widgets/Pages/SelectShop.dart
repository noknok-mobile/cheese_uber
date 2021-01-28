import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';
import 'package:flutter_cheez/Widgets/Pages/SelectAddres.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../Resources/Models.dart';
import '../../Resources/Resources.dart';
import '../../Utils/Geolocation.dart';

class SelectShop extends StatefulWidget {
  CityInfo selectedCity;
  final double _itemHeight = 40.0;
  int shopId = 0;
  Address deliveryAddress;
  String selectedAddress;

  SelectShop({this.selectedAddress});

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

  String SAVED_ADDRESSES_LIST_KEY = "SAVED_ADDRESSES_DTO_LISTS_KEY";
  Set<AddressDto> savedAddresses = Set<AddressDto>();

  Future<Address> getAddressFromCoordinates(Point point) async {
    var addresses = await Geolocation()
        .findAddressesFromCoordinates(point.latitude, point.longitude);

    return addresses[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
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

            if (widget.selectedAddress != null) {
              var addressList = await Geolocation()
                  .findAddressesFromQuery(widget.selectedAddress, context, () {
                setState(() {
                  _selectShopButtonEnabled = false;
                });
              });

              selectedLocation = Point(
                  latitude: addressList[0].coordinates.latitude,
                  longitude: addressList[0].coordinates.longitude);
            } else {
              if (Resources().geolocation.latitude != null ||
                  Resources().geolocation.longitude != null) {
                selectedLocation = Point(
                    longitude: Resources().geolocation.longitude,
                    latitude: Resources().geolocation.latitude);
              } else if (currentLong != null && currentLat != null) {
                selectedLocation =
                    Point(longitude: currentLong, latitude: currentLat);
              } else {
                selectedLocation = shops.first.mapPoint;
              }
            }
            await controller.enableCameraTracking(
                Placemark(
                    point: selectedLocation,
                    iconName: 'lib/assets/icons/address.png',
                    opacity: 1,
                    scale: 1.8,
                    iconAnchor: Point(latitude: 0.5, longitude: 1.0)),
                cameraPositionChanged);

            controller.move(point: selectedLocation);
            controller.zoomIn();
          },
        ),
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 260,
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
                            .findAddressesFromQuery(
                                addressTextField.text, context, () {
                          setState(() {
                            _selectShopButtonEnabled = false;
                          });
                        });

                        currentLocation = Point(
                            latitude: addressList[0].coordinates.latitude,
                            longitude: addressList[0].coordinates.longitude);

                        selectShop();

                        controller.move(point: currentLocation);
                        controller.zoomIn();
                      },
                    ),
                  ),
                ),
                Container(
                    height: 25.0,
                    margin: EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: FutureBuilder(
                        future:
                            Resources().getStringList(SAVED_ADDRESSES_LIST_KEY),
                        builder:
                            (context, AsyncSnapshot<Set<String>> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            savedAddresses = snapshot.data
                                .map((e) => AddressDto.fromJson(json.decode(e)))
                                .toSet();

                            return ListView.builder(
                              itemCount: savedAddresses.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.grey[200],
                                        ),
                                        margin: EdgeInsets.only(right: 10.0),
                                        padding: EdgeInsets.only(
                                            right: 10,
                                            left: 10,
                                            top: 5,
                                            bottom: 5),
                                        child: Text(
                                            savedAddresses
                                                .elementAt(index)
                                                .address,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight:
                                                    FontWeight.normal))),
                                    onTap: () async {
                                      addressTextField.text =
                                          savedAddresses.elementAt(index).city +
                                              ", " +
                                              savedAddresses
                                                  .elementAt(index)
                                                  .address;

                                      var addressList = await Geolocation()
                                          .findAddressesFromQuery(
                                              addressTextField.text, context,
                                              () {
                                        setState(() {
                                          _selectShopButtonEnabled = false;
                                        });
                                      });

                                      currentLocation = Point(
                                          latitude: addressList[0]
                                              .coordinates
                                              .latitude,
                                          longitude: addressList[0]
                                              .coordinates
                                              .longitude);

                                      selectShop();

                                      controller.move(point: currentLocation);
                                      controller.zoomIn();
                                    });
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: _selectShopButtonEnabled
                        ? CustomButton.colored(
                            expanded: true,
                            color: ColorConstants.red,
                            height: 40,
                            child: CustomText.white12px(
                                TextConstants.btnNext.toUpperCase()),
                            onClick: () {
                              selectShop();
                              if (Platform.isAndroid) {
                                saveDeliveryAddress(
                                    widget.deliveryAddress.locality,
                                    widget.deliveryAddress.thoroughfare +
                                        ", " +
                                        widget.deliveryAddress.featureName);
                              } else {
                                saveDeliveryAddress(
                                    widget.deliveryAddress.locality,
                                    widget.deliveryAddress.featureName);
                              }

                              Resources().selectShop(widget.shopId);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategoryPage()),
                                  (x) {
                                return false;
                              });
                            })
                        : CustomButton.colored(
                            expanded: true,
                            color: ColorConstants.red,
                            height: 40,
                            child: CustomText.white12px("Найти".toUpperCase()),
                            onClick: () async {
                              setState(() {
                                _selectShopButtonEnabled = true;
                              });

                              var addressList = await Geolocation()
                                  .findAddressesFromQuery(
                                      addressTextField.text, context, () {
                                setState(() {
                                  _selectShopButtonEnabled = false;
                                });
                              });

                              currentLocation = Point(
                                  latitude: addressList[0].coordinates.latitude,
                                  longitude:
                                      addressList[0].coordinates.longitude);

                              selectShop();

                              controller.move(point: currentLocation);
                              controller.zoomIn();

                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void selectShop() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setDouble("currentLong", selectedLocation.longitude);
    prefs.setDouble("currentLat", selectedLocation.latitude);
  }

  saveDeliveryAddress(String city, String address) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("currentAddress", address);

    savedAddresses.add(AddressDto(city: city, address: address));
    storeStringList(savedAddresses.map((e) => json.encode(e)).toList());

    if (Resources().userProfile.userAddress != null) {
      Resources().editAddrese(UserAddress(
          city: Resources()
              .getCityWithId(Resources().getShopWithId(widget.shopId).city)
              .name,
          addres: address));
    }
  }

  Future<void> cameraPositionChanged(dynamic arguments) async {
    final bool bFinal = arguments['final'];
    selectedLocation = Point(
        latitude: arguments['latitude'], longitude: arguments['longitude']);

    if (bFinal) {
      Address address = await getAddressFromCoordinates(selectedLocation);

      if (Platform.isAndroid) {
        addressTextField.text = address.locality +
            ", " +
            address.thoroughfare +
            ", " +
            address.featureName;
      } else {
        addressTextField.text = address.locality + ", " + address.featureName;
      }

      widget.shopId =
          (await Resources().getNearestShopByLocation(selectedLocation)).shopId;

      widget.deliveryAddress = address;
    }
  }

  void storeStringList(List<String> list) async {
    print("storeStringList --- ");
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList(SAVED_ADDRESSES_LIST_KEY, list);
  }
}

// DcA802GzGNLa
