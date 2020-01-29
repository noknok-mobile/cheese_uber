import 'dart:convert';

import 'package:flutter_cheez/Events/CustomEvent.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';

import 'Resources.dart';


GoodsData goodsDataFromJson(String str) => GoodsData.fromJson(json.decode(str));

String goodsDataToJson(GoodsData data) => json.encode(data.toJson());

abstract class IDataBaseModel{
  String localTableName();
  String toInsertTable({String tableName});
  String toUpdateTable({String tableName});
}
abstract class IDataJsonModel
{
  Map<String, dynamic> toJson();
}

class GoodsData implements IDataBaseModel,IDataJsonModel{
  static const String _localTableName = "GoodsData";
  String localTableName() =>_localTableName;

  int id;
  String imageUrl;
  String name;
  String info;
  String units;
  Set<int> categories;
  double price;

  GoodsData({
    this.id,
    this.imageUrl,
    this.name,
    this.info,
    this.units,
    this.categories,
    this.price
  });
  factory GoodsData.fromJson(Map<String, dynamic> json) =>
   GoodsData(
    id : json["id"],
    imageUrl: json["imageUrl"],
    name: json["name"],
    info: json["info"],
    price: json["price"],
    units: json["units"],
    categories: Set<int>.from(json["categories"].map((x) => x)),
  );
  @override
  Map<String, dynamic> toJson() => {
    "id" : id,
    "imageUrl": imageUrl,
    "name": name,
    "info": info,
    "price": price,
    "categories": List<dynamic>.from(categories.map((x) => x)),
  };

  static String toCreateTable({String tableName = _localTableName}){
   return "CREATE TABLE "+tableName+" ("
       "id INTEGER PRIMARY KEY,"
       "imageUrl TEXT,"
       "name TEXT,"
       "info TEXT,"
       "categories TEXT"
       "price DOUBLE,"
       ")";
  }
  @override
  String toInsertTable({String tableName = _localTableName}){
    return "INSERT Into $tableName (id,imageUrl,name,info,categories,price)"
        " VALUES (${this.id},${this.imageUrl},${this.name},${this.info},${this.categories},${this.price})";

  }
  @override
  String toUpdateTable({String tableName = _localTableName}){
    return "Update Into $tableName (id,imageUrl,name,info,categories,price)"
        " VALUES (${this.id},${this.imageUrl},${this.name},${this.info},${this.categories},${this.price})";
  }
}

class ListOfGoodsData{
  final Map<int,GoodsData> goodsData =  Map<int,GoodsData>();
  ListOfGoodsData();

  add(GoodsData data) => goodsData[data.id] = data;
  GoodsData get(int id) => goodsData[id];
  List<GoodsData> getList () => goodsData.values.toList();
  /*
  factory ListOfGoodsData.fromJson(Map<String, dynamic> json) => ListOfGoodsData(
    goodsData: Map<int,GoodsData>.from(json["goodsData"].map((x,y) => x)),
  );

  Map<String, dynamic> toJson() => {
    "goodsData": Map<int,GoodsData>.from(goodsData.map((x,y) => x.toJson)),
  };*/
}

class Cart implements IDataJsonModel,IDataBaseModel
{

  CustomWeakEvent<Cart> cartChanged = CustomWeakEvent<Cart>();

  final Map<int, int> cart = new Map<int, int>();
  final int _bonusPoints = 0;

  double get cartPrice {
    double price = 0;
    cart.forEach((k,v) => price += Resources().getGodById(k).price * v);
    return price;
  }
  double get resultPrice => cartPrice - bonusPoints.toDouble().clamp(0, cartPrice);
  double get bonusPoints => _bonusPoints.toDouble();
  int add(int id,int count){
   //cartChanged.invoke(this);

    return setCount(id, getCount(id) + count);;
  }
  int getGoodsInCartCount(){
    var num =0;
    cart.values.map((v)=>num+=v);
    return num;
  }

  int getUniqueGoodsInCart(){
    print ("getUniqueGoodsInCart");
    return cart.keys.length;
  }
  int getCount(int id){
    if(cart[id] == null)
      return 0;
    return cart[id];
  }
  int setCount(int id,int count){


    cart[id] = count == null?0:count;
    if( cart[id] <= 0)
    {
      removeAll(id);
    }

    eventBus.fire(CartUpdated(cart:this));

    return  getCount(id);
  }
  clear(){
    cart.clear();
    //cartChanged.invoke(this);
    eventBus.fire(CartUpdated(cart:this));
  }
  removeAll(int id)
  {
    if(cart[id] != null){
      cart.remove(id);
     // cartChanged.invoke(this);
      eventBus.fire(CartUpdated(cart:this));
    }
  }
  int remove(int id,int count)
  {

    return add(id,-1*count.abs());
  }

  @override
  Map<String, dynamic> toJson() => {
    "cart":json.encode(cart)
  };
  Cart();
  factory Cart.fromJson(Map<String, dynamic> newJson) => null;


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
class CategoryData{
  final int id;
  final String imageUrl;
  final String title;
  CategoryData({this.id,this.imageUrl,this.title});
}
class UserProfile {
  int bonusPoints = 0;
}

