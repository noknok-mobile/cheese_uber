import 'dart:convert';
import 'dart:math';

import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Utils/Geolocation.dart';
import 'package:flutter_cheez/Utils/NetworkUtil.dart';
import 'package:flutter_cheez/Widgets/Pages/SelectShop.dart';
import 'package:geocoder/model.dart';
import 'package:localstorage/localstorage.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:sqflite/sqflite.dart";
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'Models.dart';
import 'Models.dart';
import 'Models.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _createTables);
  }

  //Model dependency
  _createTables(Database db, int version) async {
    await db.execute(GoodsData.toCreateTable());
  }

  _insertTable(IDataBaseModel newGood) async {
    final db = await database;
    var res = await db.execute(newGood.toInsertTable());
    return res;
  }

  _updateTable(IDataBaseModel newGood) async {
    final db = await database;
    var res = await db.execute(newGood.toUpdateTable());
    return res;
  }
}

class Resources {
  static final Resources _instance = Resources._internal();
  String networkToken = "";
  String lastLoginInfo = "";
  factory Resources() {
    return _instance;
  }
  final Geolocation geolocation = Geolocation();

  final Cart _cart = Cart();
  Cart get cart => _cart;
  UserProfile _userProfile = UserProfile();
  UserProfile get userProfile => _userProfile;

  DiscountInfo discountInfo = DiscountInfo();

  List<GoodsData> allGoods = List<GoodsData>();
  List<OrderData> orders = List<OrderData>();
  List<CategoryData> categories = List<CategoryData>();
  List<Discount> discounts = List<Discount>();
  final List<ShopInfo> _allShops = List<ShopInfo>();

  List<ShopInfo> get getAllShops => _allShops;
  final List<CityInfo> _allCity = List<CityInfo>();
  List<CityInfo> get getAllCity {
    return _allCity;
  }

  final LocalStorage localStorage = LocalStorage("cheese_uber");

  Resources._internal() {
    // eventBus.on<CartUpdated>().listen((event)=>{sendBasketData(event.cart)});
  }

  void loadAllData() async {
    print("start load");
    try {
      geolocation.init();
    } catch (e) {}
    final SharedPreferences prefs = await _prefs;

    var city = prefs.getInt("city");
    var shop = prefs.getInt("shop");

    // categories.addAll(await getCategoryData());
    allGoods.addAll(await getProductData());
    _allShops.addAll(await getShopData());
    _allCity.addAll(await getCityData());

    // await getActiveDiscount();

    if (city != null && shop != null) {
      _userProfile.selectedCity = Resources().getCityWithId(city);
      _userProfile.selectedShop = shop;
    }
    eventBus.fire(AllUpToDate());
  }

  Future<void> startLoad() async {
    print("start load");
    try {
      geolocation.init();
    } catch (e) {
      print(e.toString());
    }
    final SharedPreferences prefs = await _prefs;

    var city = prefs.getInt("city");
    var shop = prefs.getInt("shop");

    _allCity.addAll(await getCityData());
    _allShops.addAll(await getShopData());

    if (city != null && shop != null) {
      _userProfile.selectedCity = Resources().getCityWithId(city);
      _userProfile.selectedShop = shop;
    }

    Resources().readCart();

    eventBus.fire(AllUpToDate());
  }

  Future<List<CityInfo>> loadCities() async {
    _allCity.addAll(await getCityData());
    eventBus.fire(AllUpToDate());
    return _allCity;
  }

  Future<List<ShopInfo>> loadShops() async {
    Future.delayed(const Duration(milliseconds: 1), () {});
    final SharedPreferences prefs = await _prefs;
    var shop = prefs.getInt("shop");

    if (shop != null) {
      _userProfile.selectedShop = shop;
    }

    _allShops.addAll(await getShopData());
    return _allShops;
  }

  Future<List<ShopInfo>> getShops() async {
    Future.delayed(const Duration(milliseconds: 1), () {});
    return _allShops;
  }

  Future<List<CategoryData>> loadCategories() async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    categories = <CategoryData>[];
    categories.addAll(await getCategoryData());
    return categories;
  }

  Future<List<GoodsData>> loadProducts() async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    // allGoods = List<GoodsData>();
    allGoods.addAll(await getProductData());
    return allGoods;
  }

  Future<List<GoodsData>> loadProductsByCategory(int categoryId) async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    // allGoods = List<GoodsData>();
    allGoods.addAll(await getProductDataByCategory(categoryId));
    return getGoodsInCategory(categoryId);
  }

  //#region Network
  Future<String> editUserData() async {
    var data =
        await NetworkUtil().post("editProfile", body: userProfile.toJson());
    return data;
  }

  Future<String> editAddrese(UserAddress address) async {
    if (!userProfile.userAddress.contains(address)) {
      userProfile.userAddress.add(address);
    }
    if (address.userID == 0) {
      address.userID = userProfile.id;
    }
    var data = await NetworkUtil().post("editAddrese",
        headers: {"Token": networkToken}, body: jsonEncode(address.toJson()));
    if (data.containsKey("errors")) return data["errors"][0]["message"];
    address.id = int.tryParse(data["ID"]);
    return data.toString();
  }

  Future<String> sendBasketData(Cart cart) async {
    var cartJson = cart.toJson();
    cartJson["Region"] = Resources()
        .getAllShops
        .firstWhere((y) => y.shopId == Resources().userProfile.selectedShop)
        .priceId;
    print(jsonEncode(cartJson));
    var data = await NetworkUtil().post("basket",
        headers: {"Token": networkToken}, body: jsonEncode(cartJson));

    if (data.containsKey("errors")) return data["errors"][0]["message"];
    return "OK";
  }

  Future<String> getPayment(int orderId) async {
    var data = await NetworkUtil().post("payment",
        headers: {"Token": networkToken},
        body: jsonEncode({"order": "$orderId"}));

    print(data);

    // if (data.containsKey("errors")) return data["errors"][0]["message"];
    return data["href"].first;
  }

  Future<String> sendOrderData(Cart cart, UserAddress address, int delivery_id,
      int payment_id, int usedbonucePoints) async {
    var cartJson = cart.toJson();
    var addressJson = address.toJson();
    cartJson["address"] = addressJson;
    cartJson["delivery"] = delivery_id;
    cartJson["payment"] = payment_id;
    cartJson["usedBonuce"] = usedbonucePoints;
    cartJson["priceType"] = Resources()
        .getAllShops
        .firstWhere((y) => y.shopId == Resources().userProfile.selectedShop)
        .priceId;
    cartJson["region"] = Resources()
        .getAllShops
        .firstWhere((y) => y.shopId == Resources().userProfile.selectedShop)
        .locationId;
    cartJson["coupon"] = cart.promocode;
    cartJson["comment"] = address.comment;

    print("sendOrderData " + jsonEncode(cartJson));
    var data = await NetworkUtil().post("order",
        headers: {"Token": networkToken}, body: jsonEncode(cartJson));

    if (data.containsKey("errors")) return data["errors"][0]["message"];

    FirebaseAnalytics().logAddPaymentInfo();
    AppmetricaSdk().reportEvent(name: 'add_payment_info');

    return "OK";
  }

  Future<String> getOrdersData() async {
    var data =
        await NetworkUtil().post("getorders", headers: {"Token": networkToken});
    orders = List<OrderData>.from(
        (data["orders"] != null ? (data["orders"] as List) : List<OrderData>())
            .map((x) => OrderData.fromJson(x))).reversed.toList();

    if (data.containsKey("errors")) return data["errors"][0]["message"];
    return "OK";
  }

  Future<List<CategoryData>> getCategoryData() async {
    var data = await NetworkUtil().post("category",
        body: jsonEncode({
          "location_id": getShopWithId(userProfile.selectedShop).locationId
        }));

    if (data == "503" || data == "504") return List<CategoryData>();

    return List<CategoryData>.from(
        ((data) as List).map((x) => CategoryData.fromJson(x)));
  }

  Future<List<GoodsData>> getProductData() async {
    return List<GoodsData>.from(((await NetworkUtil().post("product",
            body: jsonEncode({
              "shop_id": userProfile.selectedShop,
              "location_id": getShopWithId(userProfile.selectedShop).locationId
            }))) as List)
        .map((x) => GoodsData.fromJson(x)));
  }

  Future<List<GoodsData>> getProductDataByCategory(int categoryId) async {
    var data = await NetworkUtil().post("product",
        body: jsonEncode({
          "shop_id": userProfile.selectedShop,
          "section_id": categoryId,
          "location_id": getShopWithId(userProfile.selectedShop).locationId
        }));
    var lisst =
        List<GoodsData>.from((data as List).map((x) => GoodsData.fromJson(x)));

    return lisst;
  }

  Future<GoodsData> getProduct(int id) async {
    return List<GoodsData>.from(((await NetworkUtil().get(
            "product?shop_id${userProfile.selectedShop}&id=" +
                id.toString())) as List)
        .map((e) => GoodsData.fromJson(e))).first;
  }

  // List<GoodsData> getProductsInCart(Cart cart) {
  //   List<GoodsData> products = List();

  //   cart.cart.keys.forEach((element) async {
  //     products.add(await getProduct(element));
  //   });

  //   return products;
  // }

  Future<List<ShopInfo>> getShopData() async {
    return List<ShopInfo>.from(((await NetworkUtil().post("storage")) as List)
        .map((x) => ShopInfo.fromJson(x)));
  }

  Future<List<CityInfo>> getCityData() async {
    return List<CityInfo>.from(((await NetworkUtil().post("sity")) as List)
        .map((x) => CityInfo.fromJson(x)));
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> login() async {
    print("login");
    final SharedPreferences prefs = await _prefs;
    var email = prefs.getString("email");
    var pass = prefs.getString("pass");
    if (email == null || pass == null) {
      return "NO";
    }
    return await loginWithData(email, pass);
  }

  Future<String> registerWithData(
      String login, String passHash, String name, String phone) async {
    var data = await NetworkUtil().post("register",
        body: jsonEncode({
          "phone": phone,
          "login": login,
          "email": login,
          "pass": passHash,
          "platform": "android",
          "name": name,
        }));
    networkToken = data['token'];
    if (data.containsKey("errors")) return data["errors"][0]["message"];
    await getProfile(networkToken);

    return "OK";
  }

  Future<String> getProfile(String token) async {
    print('getProfile');
    var data =
        await NetworkUtil().post("profile", headers: {"Token": token}) as Map;
    print('TOKEN --- ${token}');
    _userProfile = UserProfile.fromJson(data);
    print('TOKEN --- ${data}');
    print('TOKEN --- ${_userProfile}');

    final SharedPreferences prefs = await _prefs;

    var city = prefs.getInt("city");
    var shop = prefs.getInt("shop");

    if (city != null && shop != null) {
      _userProfile.selectedCity = Resources().getCityWithId(city);

      _userProfile.selectedShop = shop;
    }
    discounts = await getActiveDiscount(token);

    if (data.containsKey("errors")) return data["errors"][0]["message"];
    print("OK");
    return "OK";
  }

  Future<String> loginWithData(String login, String passHash) async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    print('loginWithData ' + login);
    var data = await NetworkUtil().post("signin",
        body: jsonEncode(
            {"login": login, "pass": passHash, "platform": "android"})) as Map;

    networkToken = data['token'];

    if (data.containsKey("errors")) {
      eventBus.fire(NewLoginData());
      return data["errors"][0]["message"];
    }

    await getProfile(networkToken);
    eventBus.fire(NewLoginData());
    return "OK";
  }

  void logout() {
    NetworkUtil().get("signout", headers: {});
  }

  Future<List<OrderData>> getFinishedOrders() async {
    await getOrdersData();
    return orders.where((x) => x.status == "F").toList();
  }

  Future<List<OrderData>> getActiveOrders() async {
    await getOrdersData();
    return orders.where((x) => x.status != "F").toList();
  }

  Future<List<Discount>> getDiscounts() async {
    return await getActiveDiscount(networkToken);
  }

  Future<List<Discount>> getActiveDiscount(String token) async {
    var data = await NetworkUtil().post("discount");
    var discount = List<Discount>.from(data.map((x) => Discount.fromJson(x)));
    return discount;
  }

  Future<List<GoodsData>> getGoodsInCategory(int categoryId) async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    return allGoods
        .where((x) =>
            (x.categories == categoryId || categoryId == -1) &&
            x.getPrice().price != 0)
        .toList();
  }

  int getGoodsInCategoryCount(int categoryId) {
    return allGoods
        .where((x) =>
            (x.categories == categoryId || categoryId == -1) &&
            x.getPrice().price != 0)
        .toList()
        .length;
  }

  Future<bool> checkMail(String mail) async {
    await NetworkUtil().post("recover", body: jsonEncode({"email": mail}));
    return false;
  }

  Future<String> checkPromo(String promocode) async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
    var data = await NetworkUtil().post("discount",
        headers: {"Token": networkToken},
        body: jsonEncode({"promocode": promocode}));

    if (data.containsKey("errors")) return data["errors"][0]["message"];

    cart.setDiscountData(DiscountInfo.fromJson(data));
    return "";
  }
  //#endregion

  //#region AppFunction
  ShopInfo getShopWithId(int id) {
    return getAllShops.firstWhere((x) => x.shopId == id);
  }

  GoodsData getGodById(int id) {
    return allGoods.where((element) => element.id == id).first;
  }

  CityInfo getCityWithId(int id) {
    print("id " + id.toString());
    return _allCity.firstWhere((x) => x.id == id);
  }

  Future<ShopInfo> getNearestShop() async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    var shops = getAllShops;
    print("shops " +
        shops.length.toString() +
        " " +
        geolocation.getNearestShop(shops).mapPoint.toString());
    return geolocation.getNearestShop(shops);
  }

  Future<ShopInfo> getNearestShopByLocation(Point point) async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    return geolocation.getNearestShopByLocation(getAllShops, point);
  }

  Future<List<GoodsData>> getGoods() async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    return allGoods;
  }

  Future<Map<int, double>> getCart() async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    return _cart.cart;
  }

  Future<List<CategoryData>> getCategory() async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    return categories;
  }

  List<CategoryData> getCategoryWithParent(int parentId) {
    return categories.where((x) => x.parentId == parentId).toList();
  }

  CategoryData getCategoryById(int id) {
    return categories.firstWhere((x) => x.id == id, orElse: () => null);
  }

  Future<int> selectShop(int shopId) async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
    userProfile.selectedShop = shopId;
    eventBus.fire(ShopSelected(shopId));
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("shop", shopId);
    return shopId;
  }

  Future<int> selectCity(int city) async {
    var newCity = getAllShops.where((x) => x.city == city);

    userProfile.selectedCity = getCityWithId(newCity.first.city);
    userProfile.selectedShop =
        getAllShops.firstWhere((x) => x.city == city).shopId;
    print("userProfile new shop " + userProfile.selectedShop.toString());
    if (geolocation.locationData == null ||
        city != geolocation.getNearestShop(getAllShops).city) {
      geolocation.setCenterPoint(newCity);
    }
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("city", city);
    eventBus.fire(CitySelected(userProfile.selectedCity));
    return city;
  }
//#endregion

  Future<Set<String>> getStringList(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(key).toSet();
  }

  Future<Address> getAddressFromCoordinates(Point point) async {
    var addresses = await Geolocation()
        .findAddressesFromCoordinates(point.latitude, point.longitude);

    return addresses[0];
  }

  Future<String> getCurrentDeliveryAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentLong = prefs.getDouble("currentLong");
    var currentLat = prefs.getDouble("currentLat");

    Address address = await getAddressFromCoordinates(
        Point(latitude: currentLat, longitude: currentLong));

    if (Platform.isAndroid) {
      return address.locality +
          ", " +
          address.thoroughfare +
          ", " +
          address.featureName;
    } else {
      return address.locality + ", " + address.featureName;
    }
  }

  void saveDeliveryParams(UserAddress address) async {
    await localStorage.ready;
    localStorage.setItem(
        address.city + ',' + address.addres, json.encode(address));
  }

  Future<UserAddress> getDeliveryParams(String address) async {
    await localStorage.ready;
    return localStorage.getItem(address);
  }

  Future<bool> getLocalStorageReady() async {
    return await localStorage.ready;
  }

  void saveCart(Cart cart) async {
    await localStorage.ready;
    localStorage.setItem("cart", json.encode(cart));
  }

  Future<Cart> readCart() async {
    Cart loadedCart;
    if (localStorage.getItem('cart') != null) {
      loadedCart = Cart.decode(json.decode(localStorage.getItem('cart')));
    } else {
      loadedCart = Cart();
    }
    cart.setCart(loadedCart.cart);
    return loadedCart;
  }

  void clearCart() async {
    cart.setCart(Map<int, double>());
    saveCart(cart);
  }

  Future<Map<String, dynamic>> search(String query, int page) async {
    var data = await NetworkUtil()
        .get("search?n=" + query + "&PAGEN_1=" + page.toString());
    if (data == "503" || data == "504") return Map<String, dynamic>();

    var result = Map<String, dynamic>();

    var categories = List<CategoryData>.from(
        ((data["CATEGORIES"]) as List).map((x) => CategoryData.fromJson(x)));

    var products = List<GoodsData>.from(
        ((data["PRODUCTS"]) as List).map((x) => GoodsData.fromJson(x)));

    result["categories"] = categories;
    result["products"] = products;

    return result;
  }
}
