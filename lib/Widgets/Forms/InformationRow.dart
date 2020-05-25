import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';

class LabeledRow extends StatelessWidget{
  final Widget icon;
  final Widget label;
  final Widget text;

  const LabeledRow({Key key, this.icon, this.label, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        icon!=null?Container(margin:const EdgeInsets.only(right: 20) ,child:icon):Container(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            label,
            text,
          ],
        )
      ],
    );
  }
}
class PriceRow extends StatelessWidget{
  final String label = TextConstants.cartPrice;
  final double text;

  PriceRow({Key key, this.text=0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   LabeledRow(label:CustomText.black12px("${label}:"),text: CustomText.red24px("${text}"));
  }
}
class InformationRow extends StatelessWidget{
  final Widget icon;
  final String label;
  final String text;

  const InformationRow({Key key, this.icon, this.label="", this.text=""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   LabeledRow(icon:icon,label:CustomText.gray16px("${label}:"),text: CustomText.black16px("${text}"));
  }
}