
import 'package:event_bus/event_bus.dart';
import 'package:flutter_cheez/Resources/Models.dart';

EventBus eventBus = EventBus();

class UpdateCart
{
  UpdateCart({this.cart});
  final Cart cart;
}
class UpdatePrice{
  double price;
}
class AllUpToDate{

}