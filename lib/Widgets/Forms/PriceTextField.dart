import 'package:flutter/cupertino.dart';

class PriceTextField extends StatefulWidget{
  PriceTextField({


    @required this.getPrice,
    @required this.color,
    @required this.fontSize,
    this.prefix,
    this.postfix
  });
  final Widget prefix;
  final Widget postfix;
  final Function getPrice;
  final Color color;
  final int fontSize;


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
    String price = widget.getPrice();


    return Text("$price");
  }

}