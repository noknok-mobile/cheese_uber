import 'package:flutter_cheez/Resources/Models.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:location/location.dart';
import 'dart:math' as math;

class Geolocation {
  Location location = new Location();
  final Geocoding mode = Geocoder.local;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  LocationData locationData;

  double latitude = 45.035570;
  double longitude = 38.985323;
  Geolocation({this.latitude, this.longitude});
  Future<void> init() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await location.getLocation();
    latitude = locationData.latitude;
    longitude = locationData.longitude;
  }

  void setCenterPoint(Iterable<ShopInfo> shops) {
    latitude = shops.first.mapPoint.latitude;
    longitude = shops.first.mapPoint.longitude;

    math.Point myPoint = math.Point(
        shops.first.mapPoint.latitude, shops.first.mapPoint.longitude);
    shops.forEach((x) => {
          latitude = (latitude + x.mapPoint.latitude) / 2,
          longitude = (longitude + x.mapPoint.longitude) / 2,
        });
    /*latitude /= shops.length;
      longitude /= shops.length;
*/
  }

  ShopInfo getNearestShop(List<ShopInfo> shops) {
    shops.sort((a, b) {
      math.Point myPoint = math.Point(this.latitude, this.longitude);
      return myPoint
              .distanceTo(math.Point(a.mapPoint.latitude, a.mapPoint.longitude))
              .floor() -
          myPoint
              .distanceTo(math.Point(b.mapPoint.latitude, b.mapPoint.longitude))
              .floor();
    });
    return shops.first;
  }

  Future<List<Address>> findAddressesFromQuery(String address) async {
    try {
      var geocoding = mode;
      var results = await geocoding.findAddressesFromQuery(address);
      return results;
    } catch (e) {
      print("Error occured: $e");
    } finally {}
    return List<Address>();
  }

  Future<List<Address>> findAddressesFromCoordinates(
      double latitude, double longitude) async {
    try {
      var geocoding = mode;
      var results = await geocoding
          .findAddressesFromCoordinates(Coordinates(latitude, longitude));
      return results;
    } catch (e) {
      print("Error occured: $e");
    } finally {}
    return List<Address>();
  }
}
