import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget{
  bool value = true;
  bool active = true;
  double width = double.infinity;
  double height = double.infinity;
  Widget enabledWidget = Container();
  Widget disabledWidget = Container();
  var onChanged;
  CustomCheckBox({Key key,this.enabledWidget,this.disabledWidget,this.value,this.onChanged,this.width,this.height,this.active: true}): super(key: key);
  @override
  State<StatefulWidget> createState() =>_stateCustomCheckBox();
}
class _stateCustomCheckBox extends State<CustomCheckBox>{
  @override
  Widget build(BuildContext context) {

    return Container(
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: widget.value?CrossFadeState.showFirst:CrossFadeState.showSecond,
          firstChild: widget.enabledWidget,
          secondChild: widget.disabledWidget,
        ),
        onTap: ()=> setState(()
        {
          if(widget.active)
            widget.value = !widget.value;
          if(widget.onChanged != null) widget.onChanged(widget.value);

        }),
      ),
    );
  }



}