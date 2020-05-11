
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Utils/Geolocation.dart';
import "package:sqflite/sqflite.dart";
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'Models.dart';
class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: _createTables
    );
  }


  //Model dependency
  _createTables(Database db, int version) async{
      await db.execute(GoodsData.toCreateTable());

  }
  _insertTable(IDataBaseModel newGood) async{
      final db = await database;
      var res = await db.execute(newGood.toInsertTable());
      return res;
  }
  _updateTable(IDataBaseModel newGood) async{
    final db = await database;
    var res = await db.execute(newGood.toUpdateTable());
    return res;
  }

}
class Resources {
  static final Resources _instance = Resources._internal();
  factory Resources() {
    return _instance;
  }
  final Geolocation geolocation= Geolocation();

  final Cart _cart = Cart();
  Cart get cart => _cart;
  final UserProfile _userProfile = UserProfile();
  UserProfile get userProfile => _userProfile;


  final ListOfGoodsData _allGoods = ListOfGoodsData();

  final List<CategoryData> categories = List<CategoryData>();

  final List<ShopInfo> _allShops =List<ShopInfo>();

  List<ShopInfo> get getAllShops =>_allShops;

  List<String> get getAllCity{
    return getAllShops.map((x)=>x.city).toSet().toList();
  }

  Resources._internal() {
    for(int i=0;i<50;i++) {
      _allGoods.add(GoodsData(
          id: i,
          imageUrl: "https://yandex.ru/images/_crpd/Q1D5n2B99/ce0015_uy/72m6rPQz_7LlbwH6bW5KMM2w6e8WlIcti2VBqik_8GH4V9QeY9xV3MJcbQp5s_tmqqxrTz_FaDAemhQBRpPCo_pssoSJC-_u9HJI8iyrKjHdyJS3P9HHWLoUDJpUY-AgwDKBQo_VVZ3zHTxL0b_zftQ",
          name: "Это сыр №$i он очень вкусный . сырный сыр лучше не сырного сыра",
          info: "- белки до 25;\n- жиры до 60;\n- углеводы до 3,5.\n \nЯвляется высоко калорийным продуктом калорийностью, и в зависимости от содержания жира и белка составляет от 250 до 400 ккал на 100 грамм сыра.",
          categories: {i%5},
          price: i*100.0 + i%2*50.0,
          units: i%4 == 0?TextConstants.wUnits:TextConstants.units
      ));
    }
    ShopInfo shop = ShopInfo();
    getAllShops.add(shop);
    shop = ShopInfo(shopId: "2",city: "Адлер",mapPoint: Point(latitude:30,longitude:-58));
    getAllShops.add(shop);
    shop = ShopInfo(shopId: "3",city: "Краснодар",address: "Горького 123",mapPoint:Point(latitude:45.035470, longitude:38.975313));
    getAllShops.add(shop);
    shop = ShopInfo(shopId: "4",city: "Краснодар",address: "ул Горького 233",mapPoint:Point(latitude:45.03548,longitude:38.976));
    getAllShops.add(shop);
    shop = ShopInfo(shopId: "5",city: "Сочи");
    getAllShops.add(shop);

    for(int i=0;i<5;i++) {
      categories.add(CategoryData(id: i,imageUrl:"https://avatars.mds.yandex.net/get-pdb/25978/37a535b5-ccb6-4a91-9d9e-b32690652b7c/s1200",title: "Вкусные сыры очень не плохи $i" ));
    }
  }



  void loadAllData() async{
    print("start load");
    try{
      await geolocation.init();
    } catch(e){


    }



  //  await LocationPermissions().checkServiceStatus();
    await Future.delayed(const Duration(milliseconds: 5000), (){});
    eventBus.fire(AllUpToDate());
    print("end load");
  }

  ShopInfo getShopWithId(String id){
    return getAllShops.firstWhere((x)=>x.shopId == id);
  }
  GoodsData getGodById(int id){
    return _allGoods.get(id);
  }
  Future <ShopInfo> getNearestShop()async{
    var shops = getAllShops;
    await Future.delayed(const Duration(milliseconds: 1), (){});

    return  geolocation.getNearestShop(shops);
  }

  Future <List<GoodsData>>getGoodsInCategory(int categoryId)async{
    await Future.delayed(const Duration(milliseconds: 1), (){});
    return _allGoods.getList().where((x)=>x.categories.contains(categoryId) || categoryId == -1).toList();
  }
  Future <List<GoodsData>>getGoods()async{
    await Future.delayed(const Duration(milliseconds: 1), (){});
    return _allGoods.getList();
  }
  Future <Map<int,int>>getCart()async{
    await Future.delayed(const Duration(milliseconds: 1), (){});
    return _cart.cart;
  }
  Future <List<CategoryData>>getCategory()async{
    await Future.delayed(const Duration(milliseconds: 1), (){});
    return categories;
  }
  Future <CategoryData>getCategoryById(int id)async{
    await Future.delayed(const Duration(milliseconds: 1), (){});
    return categories.firstWhere((x)=>x.id == id);
  }

  Future <String> selectShop(String shopId)async{
    await Future.delayed(const Duration(milliseconds: 1), (){});
    userProfile.selectedShop = shopId;
    eventBus.fire(ShopSelected(shopId));
    return shopId;
  }
  Future <String> selectCity(String city)async{
    await Future.delayed(const Duration(milliseconds: 1), (){});
    if(geolocation.locationData == null || city != geolocation.getNearestShop(getAllShops).city){
      geolocation.setCenterPoint(getAllShops.where((x)=>x.city == city));
    }
    eventBus.fire(CitySelected(city));
    return city;
  }

}




