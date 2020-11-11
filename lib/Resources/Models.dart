import 'dart:convert';

import 'package:flutter_cheez/Utils/TextUtils.dart';
import 'package:flutter_cheez/Events/CustomEvent.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'Resources.dart';

GoodsData goodsDataFromJson(String str) => GoodsData.fromJson(json.decode(str));

String goodsDataToJson(GoodsData data) => json.encode(data.toJson());

abstract class IDataBaseModel {
  String localTableName();
  String toInsertTable({String tableName});
  String toUpdateTable({String tableName});
}

abstract class IDataJsonModel {
  Map<String, dynamic> toJson();
}

class PriceData implements IDataJsonModel {
  @override
  Map<String, dynamic> toJson() => {
        "CATALOG_GROUP_ID": storeId,
        "PRICE": price,
        "CURRENCY": currency,
        "PRODUCT_QUANTITY": quantity,
      };
  final int storeId;
  double price;
  final String currency;
  final double quantity;
  @override
  factory PriceData.fromJson(Map<String, dynamic> json) => PriceData(
        storeId: int.parse(json["CATALOG_GROUP_ID"]),
        price: double.parse(json["PRICE"]),
        currency: json["CURRENCY"],
        quantity: json["PRODUCT_QUANTITY"] != null
            ? double.tryParse(json["PRODUCT_QUANTITY"])
            : 0,
      );

  PriceData({
    this.storeId = 0,
    this.price = 0,
    this.currency = "rub",
    this.quantity = 0,
  });
}

class GoodsData implements IDataBaseModel, IDataJsonModel {
  static const String _localTableName = "GoodsData";
  String localTableName() => _localTableName;

  int id;
  String imageUrl;
  String detailImageUrl;
  String name;
  String previewText;
  String detailText;
  int categories = 0;
  List<PriceData> price;
  String units = "шт";

  PriceData getPrice() {
    // cart.forEach((k,v) =>print(Resources().getGodById(k)));
    return price.firstWhere(
        (x) =>
            Resources()
                .getAllShops
                .firstWhere(
                    (y) => y.shopId == Resources().userProfile.selectedShop)
                .priceId ==
            x.storeId,
        orElse: () => PriceData());
  }

  PriceData getPriceWithShopId(int shopID) {
    return price.firstWhere((x) => x.storeId == shopID);
  }

  GoodsData(
      {this.id,
      this.imageUrl,
      this.name,
      this.previewText,
      this.detailText,
      this.units,
      this.categories,
      this.price,
      this.detailImageUrl});
  factory GoodsData.fromJson(Map<String, dynamic> json) {
    var price = json["PRICES"] != null
        ? List<PriceData>.from(((json["PRICES"].values as Iterable)
            .map((x) => PriceData.fromJson(x))))
        : List<PriceData>();
    var mesure = json["MEASURE"] == "кг" ? "кг" : json["MEASURE"];
    if (mesure == "гр") {
      price.forEach((x) => {x.price = (x.price).roundToDouble()});
    }
    return GoodsData(
      id: int.parse(json["ID"]),
      imageUrl: json["PREVIEW_PICTURE"],
      detailImageUrl: json["DETAIL_PICTURE"],
      name: json["NAME"].toString().replaceHTMLSpecialChars(),
      previewText:
          json["PREVIEW_TEXT"].toString().replaceHTMLSpecialChars() + " ",
      detailText:
          json["DETAIL_TEXT"].toString().replaceHTMLSpecialChars() + " ",
      price: price,
      units: mesure != null ? mesure : 'шт',
      categories: int.parse(json["IBLOCK_SECTION_ID"]),
    );
  }
  @override
  Map<String, dynamic> toJson() => {
        "ID": id,
        "PREVIEW_PICTURE": imageUrl,
        "NAME": name,
        "PREVIEW_TEXT": previewText,
        "DETAIL_TEXT": detailText,
        "IBLOCK_SECTION_ID": categories,
      };

  static String toCreateTable({String tableName = _localTableName}) {
    return "CREATE TABLE " +
        tableName +
        " ("
            "id INTEGER PRIMARY KEY,"
            "imageUrl TEXT,"
            "name TEXT,"
            "info TEXT,"
            "categories TEXT"
            "price DOUBLE,"
            ")";
  }

  @override
  String toInsertTable({String tableName = _localTableName}) {
    return "INSERT Into $tableName (id,imageUrl,name,info,categories,price)"
        " VALUES (${this.id},${this.imageUrl},${this.name},${this.previewText},${this.categories},${this.price})";
  }

  @override
  String toUpdateTable({String tableName = _localTableName}) {
    return "Update Into $tableName (id,imageUrl,name,info,categories,price)"
        " VALUES (${this.id},${this.imageUrl},${this.name},${this.previewText},${this.categories},${this.price})";
  }
}

class ListOfGoodsData {
  final Map<int, GoodsData> goodsData = Map<int, GoodsData>();
  ListOfGoodsData();

  add(GoodsData data) => goodsData[data.id] = data;
  GoodsData get(int id) => goodsData[id];
  List<GoodsData> getList() => goodsData.values.toList();

  void addAll(Iterable<GoodsData> data) {
    data.forEach((x) => add(x));
  }

  /*
  factory ListOfGoodsData.fromJson(Map<String, dynamic> json) => ListOfGoodsData(
    goodsData: Map<int,GoodsData>.from(json["goodsData"].map((x,y) => x)),
  );

  Map<String, dynamic> toJson() => {
    "goodsData": Map<int,GoodsData>.from(goodsData.map((x,y) => x.toJson)),
  };*/
}

class Discount implements IDataJsonModel, IDataBaseModel {
  int id;
  String name;
  String imageUrl;
  String detailImageUrl;
  String title;
  String detailText;
  String coupon;
  Discount(
      {this.id,
      this.imageUrl,
      this.detailImageUrl,
      this.title,
      this.detailText,
      this.coupon,
      this.name});
  @override
  String localTableName() {
    // TODO: implement localTableName
    return null;
  }

  @override
  String toInsertTable({String tableName}) {
    // TODO: implement toInsertTable
    return null;
  }

  @override
  Map<String, dynamic> toJson() => {
        "ID": id,
        "PREVIEW_PICTURE": imageUrl,
        "DETAIL_PICTURE": detailImageUrl,
        "PREVIEW_TEXT": title,
        "DETAIL_TEXT": detailText,
        "COUPON": coupon,
        "NAME": name,
      };
  factory Discount.fromJson(Map<String, dynamic> newJson) => Discount(
        id: int.parse(newJson["ID"]),
        imageUrl: newJson["PREVIEW_PICTURE"],
        detailImageUrl: newJson["DETAIL_PICTURE"],
        title: newJson["PREVIEW_TEXT"],
        detailText: newJson["DETAIL_TEXT"],
        name: newJson["NAME"],
        coupon: newJson["COUPON"] != null ? newJson["COUPON"] : "",
      );
  @override
  String toUpdateTable({String tableName}) {
    // TODO: implement toUpdateTable
    return null;
  }
}

class Cart implements IDataJsonModel, IDataBaseModel {
  CustomWeakEvent<Cart> cartChanged = CustomWeakEvent<Cart>();

  Map<int, double> cart = new Map<int, double>();
  Map<int, double> savedCartPrice = new Map<int, double>();
  int _bonusPoints = 0;
  String promocode = "";
  DiscountInfo discountInfo = DiscountInfo();

  double get cartPrice {
    double price = 0;

    cart.forEach((k, v) {
      if (savedCartPrice.containsKey(k)) {
        price += savedCartPrice[k] * v;
      } else {
        price += Resources().getGodById(k).getPrice().price * v;
      }
    });
    return price;
  }

  double get resultPrice =>
      cartPrice -
      bonusPoints.toDouble().clamp(0, cartPrice) -
      cartPrice * discountInfo.discountValue * 0.01;
  double get bonusPoints => _bonusPoints.toDouble();
  set setBonusPoints(int val) {
    if (val > cartPrice / 2)
      _bonusPoints = (cartPrice / 2).toInt();
    else
      _bonusPoints = val;
    eventBus.fire(CartUpdated(cart: this));
  }

  set setPromocode(String val) {
    promocode = val;
    eventBus.fire(CartUpdated(cart: this));
  }

  double add(int id, int count) {
    cartChanged.invoke(this);

    return setCount(id, getCount(id) + count);
    ;
  }

  void clearDiscountData() {
    discountInfo = DiscountInfo();

    eventBus.fire(CartUpdated(cart: this));
  }

  void setDiscountData(DiscountInfo val) {
    discountInfo = val;

    eventBus.fire(CartUpdated(cart: this));
  }

  double getGoodsInCartCount() {
    double num = 0;
    cart.values.map((v) => num += v);
    return num;
  }

  double getGoodsInCartPrice(int id) {
    double price = 0;
    if (savedCartPrice.containsKey(id)) {
      price += savedCartPrice[id] * cart[id];
    } else {
      price += Resources().getGodById(id).getPrice().price * cart[id];
    }
    return price;
  }

  int getUniqueGoodsInCart() {
    print("getUniqueGoodsInCart");
    return cart.keys.length;
  }

  double getCount(int id) {
    if (cart[id] == null) return 0;
    return cart[id];
  }

  double setCount(int id, double count) {
    setBonusPoints = bonusPoints.toInt();
    cart[id] = count == null ? 0 : count;
    if (cart[id] <= 0) {
      removeAll(id);
    }

    eventBus.fire(CartUpdated(cart: this));

    return getCount(id);
  }

  clear() {
    cart.clear();
    savedCartPrice.clear();
    _bonusPoints = 0;
    cartChanged.invoke(this);

    eventBus.fire(CartUpdated(cart: this));
  }

  removeAll(int id) {
    if (cart[id] != null) {
      cart.remove(id);
      cartChanged.invoke(this);
      eventBus.fire(CartUpdated(cart: this));
    }
  }

  double remove(int id, int count) {
    return add(id, -1 * count.abs());
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
    cart.forEach((x, y) {
      map[x.toString()] = y.toString();
    });

    return {'cart': map};
  }

  Cart();
  void setCart(Map<int, double> newCart) {
    clear();

    newCart.forEach((key, value) => {
          if (Resources().getGodById(key).getPrice().price != 0)
            cart[key] = value
        });

    //cart = newCart;
  }

  Cart.fromData({this.cart, this.savedCartPrice});
  factory Cart.fromJson(Map<String, dynamic> newJson) {
    Map<int, double> map = Map();
    Map<int, double> mapPrice = Map();
    if (newJson["BASKET"] != null) {
      (newJson["BASKET"] as List).forEach((x) => {
            map[int.parse(x["ID"])] = (x["QUANTITY"].toDouble()),
            mapPrice[int.parse(x["ID"])] = (x["PRICE"].toDouble())
          });
    }

    return Cart.fromData(cart: map, savedCartPrice: mapPrice);
  }

  @override
  String localTableName() {
    // TODO: implement localTableName
    return null;
  }

  @override
  String toInsertTable({String tableName}) {
    // TODO: implement toInsertTable
    return null;
  }

  @override
  String toUpdateTable({String tableName}) {
    // TODO: implement toUpdateTable
    return null;
  }
}

enum OrderStatus { done, call, delivery, pay }
enum PayType { cash, online }
enum DeliveryType { courier, pickup }

class OrderData {
  final String status;
  final int id;
  final DateTime orderTime;
  final DateTime orderEndTime;
  final Cart cart;
  final PayType payType;
  final DeliveryType deliveryType;
  final double deliveryPrice;
  final double price;
  final UserAddress userAddress;

  OrderData({
    this.id,
    this.orderTime,
    this.cart,
    this.orderEndTime,
    this.status,
    this.payType,
    this.userAddress,
    this.deliveryType,
    this.deliveryPrice,
    this.price,
  });

  factory OrderData.fromJson(Map<String, dynamic> newJson) {
    final DateFormat format = DateFormat("dd.MM.yyyy H:m:s");
    return OrderData(
        id: int.parse(newJson["ID"]),
        orderTime: format.parse(newJson["DATE_INSERT"]),
        orderEndTime: format.parse(newJson["DATE_UPDATE"]),
        deliveryType: int.tryParse(newJson["DELIVERY_ID"]) == 2
            ? DeliveryType.pickup
            : DeliveryType.courier,
        status: newJson["STATUS_ID"],
        deliveryPrice: double.parse(newJson["PRICE_DELIVERY"]),
        price: double.parse(newJson["PRICE"]),
        userAddress: UserAddress.fromJson(newJson["profile"]),
        cart: Cart.fromJson(newJson));
  }
}

class CategoryData {
  final int id;
  final String imageUrl;
  final String title;
  final int parentId;
  final int sort;
  int elementCount = 0;
  CategoryData(
      {this.id,
      this.imageUrl,
      this.title,
      this.parentId,
      this.sort,
      this.elementCount});

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
      id: int.parse(json["ID"]),
      imageUrl: json["PICTURE"],
      title: json["NAME"],
      parentId: json["IBLOCK_SECTION_ID"] != null
          ? int.parse(json["IBLOCK_SECTION_ID"])
          : 0,
      sort: json["SORT"] != null ? int.parse(json["SORT"]) : 0,
      elementCount: int.parse(json["ELEMENT_CNT"]));

  @override
  Map<String, dynamic> toJson() => {
        "ID": id,
        "PICTURE": imageUrl,
        "NAME": title,
        "IBLOCK_SECTION_ID": parentId,
        "SORT": sort,
      };
}

class UserAddress {
  int id = 0;
  int userID = 0;
  String name = "";
  String city = "Краснодар";
  String phone = "";
  String username = "";
  String addres = "Краснодар Ул. Красная, 23";
  String comment = "";
  String entrance = "";
  String floor = "";
  String flat = "";
  UserAddress(
      {this.id = 0,
      this.userID = 0,
      this.city = " ",
      this.addres = " ",
      this.phone = "+7(",
      this.username = " ",
      this.name = "Новый адрес",
      this.entrance = " ",
      this.floor = " ",
      this.flat = " ",
      this.comment = ""});
  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: int.parse(json["id"]),
        userID: int.parse(json["user_id"]),
        name: json["name"],
        city: json['data']["5"],
        addres: json['data']["7"],
        phone: json['data']["3"],
        username: json['data']["1"],
        entrance: json['data']["23"],
        floor: json['data']["24"],
        flat: json['data']["25"],
      );
  @override
  Map<String, dynamic> toJson() => {
        "ID": id.toString(),
        "USER_ID": userID.toString(),
        "NAME": name,
        "1": username,
        "3": phone,
        "7": addres,
        "5": city,
        "23": entrance.toString(),
        "24": floor.toString(),
        "25": flat.toString(),
        "comment": comment.toString()
      };
}

class CityInfo {
  final int id;
  final String name;
  final String previewImage;

  factory CityInfo.fromJson(Map<String, dynamic> json) => CityInfo(
        id: int.parse(json["ID"]),
        name: json["NAME"],
        previewImage: json["PICTURE"],
      );
  @override
  Map<String, dynamic> toJson() => {
        "ID": id,
        "NAME": name,
        "PICTURE": previewImage,
      };
  CityInfo({
    this.id,
    this.name,
    this.previewImage,
  });
}

class DiscountInfo {
  final String name;
  final String status;
  final String discountType;
  final double discountValue;

  final double resultDiscount;
  final double price;
  final double basePrice;
  DiscountInfo(
      {this.name = "",
      this.status = "INNACTIVE",
      this.discountType = "",
      this.discountValue = 0,
      this.resultDiscount = 0,
      this.price = 0,
      this.basePrice = 0});
  factory DiscountInfo.fromJson(Map<String, dynamic> json) => DiscountInfo(
        name: json["name"],
        status: json["status"],
        discountType: json["discountType"],
        discountValue: json["discountValue"].toDouble(),
        resultDiscount: json["resultDiscount"].toDouble(),
        price: json["price"].toDouble(),
        basePrice: json["basePrice"].toDouble(),
      );
  @override
  Map<String, dynamic> toJson() => {
        "status": status,
        "discountType": discountType,
        "discountValue": discountValue,
        "resultDiscount": resultDiscount,
        "price": price,
        "basePrice": basePrice,
      };
}

class ShopInfo {
  final int id;
  final int shopId;
  final int priceId;
  final int locationId;
  final int city;
  final String address;
  final List<String> phones;
  final Point mapPoint;
  final String workTime;
  final String detailText;
  final String previewImage;
  final String detailImage;
  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        id: int.parse(json["ID"]),
        shopId: int.parse(json["STORE_ID"].first),
        priceId: int.parse(json["PRICE_ID"].first),
        locationId: int.parse(json["LOCATION_LINK"]),
        city: int.parse(json["SITY_ID"]),
        address: json["ADDRESS"].toString(),
        phones: json["PHONES"].toString().split(','),
        mapPoint: Point(
            latitude: double.parse(json["MAP_POINTS"].toString().split(',')[0]),
            longitude:
                double.parse(json["MAP_POINTS"].toString().split(',')[1])),
        workTime: json["WORK_TIME"],
        detailText: json["DETAIL_TEXT"],
        previewImage: json["PREVIEW_PICTURE"],
        detailImage: json["DETAIL_PICTURE"],
      );
  @override
  Map<String, dynamic> toJson() => {
        "ID": id,
        "STORE_ID": shopId,
        "PRICE_ID": priceId,
        "LOCATION_LINK": locationId,
        "ADDRESS": address,
        "PHONES": phones,
        "MAP_POINTS": [
          mapPoint.latitude.toString(),
          mapPoint.longitude.toString()
        ],
        "WORK_TIME": workTime,
        "DETAIL_TEXT": detailText,
        "PREVIEW_PICTURE": previewImage,
        "DETAIL_PICTURE": detailImage,
      };
  ShopInfo({
    this.shopId = 0,
    this.city = 0,
    this.address = "",
    this.priceId = 1,
    this.locationId = 4866,
    this.mapPoint = const Point(latitude: 0.0, longitude: 0.0),
    this.id = 0,
    this.phones = const [''],
    this.workTime = "",
    this.detailText = "",
    this.previewImage = "",
    this.detailImage = "",
  });
}

class UserProfile {
  int id;
  double bonusPoints = 0;
  String username = "anonimus";
  String email = "ivanIvanov@gmail.com";

  String phone = "";
  int selectedShop = 0;
  CityInfo selectedCity;
  List<UserAddress> userAddress = List<UserAddress>();
  bool defaultAddrese = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserProfile(
      {this.id,
      this.bonusPoints = 0,
      this.selectedShop = 0,
      this.username = "anonimus",
      this.phone,
      this.email,
      this.userAddress}) {
    _prefs.then((value) {
      var shop = value.getInt("shop");
      var addressList = value.getStringList("SAVED_ADDRESSES_LIST_KEY");
      print(addressList);
      if (shop != null) {
        selectedShop = shop;
        if (addressList != null)
          addressList.forEach((element) {
            userAddress.add(UserAddress(
                city: Resources()
                    .getCityWithId(Resources().getShopWithId(shop).city)
                    .name,
                addres: element));
          });
      }
    });
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: int.parse(json["id"]),
        bonusPoints: double.parse(json["bonuse"]),
        username: json["name"] + json["lastName"],
        email: json["email"],
        phone: json["phone"],
        userAddress: json["userProps"] != null
            ? List<UserAddress>.from(
                (json["userProps"].values).map((x) => UserAddress.fromJson(x)))
            : List<UserAddress>(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "ID": id,
        "NAME": username,
        "EMAIL": email,
        "PHONE": phone,
        "PROPS": jsonEncode(userAddress.map((x) => x.toJson())),
      };
}
