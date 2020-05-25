import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class CustomInputField extends StatefulWidget{
  @protected
  Widget content;
  @override
  State<StatefulWidget> createState()=>CustomInputFieldState();
  @protected
  void onTap(){}

}
class CustomInputFieldState extends State<CustomInputField>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        child:widget.content,
        onTap: (){
          setState(() {
            widget.onTap();
          });
        },
    );
  }
}