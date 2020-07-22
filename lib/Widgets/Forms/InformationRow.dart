import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';

class LabeledRow extends StatelessWidget{
  final Widget icon;
  final Widget label;
  final Widget text;
  final Widget posfix;
  const LabeledRow({Key key, this.icon, this.label, this.text,this.posfix}) : super(key: key);

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
        ),
        Expanded(child: Container(),),
        posfix,
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
    return   LabeledRow(label:CustomText.black12px("${label}:"),text: CustomText.red24px("${text}"),posfix: Container(),);
  }
}
class InformationRow extends StatelessWidget{
  final Widget icon;
  final String label;
  final String text;
  final String posfix;
  const InformationRow({Key key, this.icon, this.label="", this.text="",this.posfix = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   LabeledRow(icon:icon,label:CustomText.darkGray16px("${label}:"),text: CustomText.black16px("${text}"),posfix: CustomText.black16px("${posfix}"),);
  }
}