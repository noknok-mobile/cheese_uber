
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import "package:sqflite/sqflite.dart";
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


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
  final Cart _cart = Cart();
  Cart get cart => _cart;
  final ListOfGoodsData _allGoods = ListOfGoodsData();

  final List<CategoryData> categories = List<CategoryData>();


  Resources._internal() {
    for(int i=0;i<50;i++) {
      _allGoods.add(GoodsData(
          id: i,
          imageUrl: "https://yandex.ru/images/_crpd/Q1D5n2B99/ce0015_uy/72m6rPQz_7LlbwH6bW5KMM2w6e8WlIcti2VBqik_8GH4V9QeY9xV3MJcbQp5s_tmqqxrTz_FaDAemhQBRpPCo_pssoSJC-_u9HJI8iyrKjHdyJS3P9HHWLoUDJpUY-AgwDKBQo_VVZ3zHTxL0b_zftQ",
          name: "Это сыр №$i он очень вкусный . сырный сыр лучше не сырного сыра",
          info: "вкусный сыр это не то и того не туда. Каждый сыр хочет знать где сидит пармезаныч",
          categories: {i%5},
          price: i*100.0 + i%2*50.0,
          units: i%4 == 0?"гр":"шт"
      ));
    }
    for(int i=0;i<5;i++) {
      categories.add(CategoryData(id: i,imageUrl:"https://avatars.mds.yandex.net/get-pdb/25978/37a535b5-ccb6-4a91-9d9e-b32690652b7c/s1200",title: "Вкусные сыры очень не плохи $i" ));
    }
  }

  void loadAllData() async{
    print("start load");
    await Future.delayed(const Duration(milliseconds: 5000), (){});
    eventBus.fire(AllUpToDate());
    print("end load");
  }

  GoodsData getGodById(int id){
    return _allGoods.get(id);
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


}




