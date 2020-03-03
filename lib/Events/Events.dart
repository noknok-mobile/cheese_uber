
import 'package:event_bus/event_bus.dart';
import 'package:flutter_cheez/Resources/Models.dart';

EventBus eventBus = EventBus();

class CartUpdated
{
  CartUpdated({this.cart});
  final Cart cart;
}
class GoodInCartUpdated
{
  GoodInCartUpdated({ this.id,this.count = 0});
  final int id;
  final int count;
}

class GoodInCartAdd{
  final int id;
  final int count;
  GoodInCartAdd({ this.id,this.count = 1});
}
class GoodInCartRemove{
  int id;
  int count = 1;
  GoodInCartRemove({ this.id,this.count = 1});
}
class GoodInCartSet{
  int id;
  int count;
  GoodInCartSet({ this.id,this.count = 1});
}
class CitySelected{
  final String city;
  CitySelected(this.city);
}
class ShopSelected{
  final String shopId;
  ShopSelected(this.shopId);
}
class AllUpToDate{

}