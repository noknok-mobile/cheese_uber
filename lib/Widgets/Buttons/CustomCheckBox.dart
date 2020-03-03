import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget{
  bool value = true;
  double width = double.infinity;
  double height = double.infinity;
  Widget enabledWidget = Container();
  Widget disabledWidget = Container();
  Function onChanged = (x){};
  CustomCheckBox({Key key,this.enabledWidget,this.disabledWidget,this.value,this.onChanged,this.width,this.height}): super(key: key);
  @override
  State<StatefulWidget> createState() =>_stateCustomCheckBox();
}
class _stateCustomCheckBox extends State<CustomCheckBox>{
  @override
  Widget build(BuildContext context) {

    return Container(
      width: widget.width,
      height: widget.height,
      child: FlatButton(
        child: widget.value?widget.enabledWidget:widget.disabledWidget,
        onPressed: ()=> setState(()=>{ widget.value = !widget.value,widget.onChanged(widget.value)}),
      ),
    );
  }



}