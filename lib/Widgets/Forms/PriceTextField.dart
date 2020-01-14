import 'package:flutter/cupertino.dart';

class PriceTextField extends StatefulWidget{
  PriceTextField(
      this.getPrice
      );
  Function getPrice;


  @override
  State<StatefulWidget> createState() =>_PriceTextFieldState();
}
class _PriceTextFieldState extends State<PriceTextField>
{
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    double price = widget.getPrice();


    return Text("$price");
  }

}