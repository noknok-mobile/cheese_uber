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

class SelectAddres extends StatefulWidget {

  final double _itemHeight = 40.0;
  int shopId = 0;


  @override
  State<StatefulWidget> createState() => _SelectAddresState();
}

Point currentLocation;

class _SelectAddresState extends State<SelectAddres> {
  YandexMapController controller;

  @override
  Widget build(BuildContext context) {


    var query = MediaQuery.of(context);

    Resources().selectShop(widget.shopId);
    // TODO: implement build
    return Scaffold(
      body: YandexMap(
        
        onMapCreated: (YandexMapController yandexMapController) async {
          controller = yandexMapController;
          await controller.addPlacemark(Placemark(
            point: Point(
                longitude: Resources().geolocation.longitude,
                latitude: Resources().geolocation.latitude),
            opacity: 1,
            scale: 2,
            iconName: 'lib/assets/icons/check_box.png',
          ));
          // currentLocation = await controller.getTargetPoint();
          controller.move(
              point: Point(
                  longitude: Resources().geolocation.longitude,
                  latitude: Resources().geolocation.latitude));
          controller.zoomIn();
          controller.getTargetPoint();
          await controller.showUserLayer(
              iconName: 'lib/assets/check_box.png',
              arrowName: 'lib/assets/check_box.png',
              accuracyCircleFillColor: Colors.green.withOpacity(0.5)
          );
        },
      ),
      bottomNavigationBar: Container(
        // margin: EdgeInsets.all(20),
        height: 200,
        decoration: ParametersConstants.BoxShadowDecoration,
        //  height: shopsInCity.length * widget._itemHeight + 75 + 45,
        child: Column(

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
                        Navigator.of(context).pop()
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
