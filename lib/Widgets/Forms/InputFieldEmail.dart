

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';

class InputFieldEmail extends StatefulWidget{
  final label;
  final TextInputType textInputType;
  final double height;
  final bool decorated;
  final SharedValue<String> value;
  TextEditingController _controller = new TextEditingController();
  InputFieldEmail(
      {Key key, this.label = "E-Mail",
        this.textInputType = TextInputType.emailAddress,
        this.height = 45.0,
        this.value, this.decorated = true,
      }): super(key: key){
    print('value '+ value.value);
    _controller.text = value.value;
  }

  @override
  State<StatefulWidget> createState()=>InputFieldEmailState();
  @protected
  void onTap(){}

}
class InputFieldEmailState extends State<InputFieldEmail>{

  String validateEmail(String value) {

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Введите верный E-Mmail';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
  print("build "+widget.value.value);
    // TODO: implement build
    return  Container(
        height: widget.height,
        child: TextFormField(
         // initialValue: widget.value.value,
          maxLines: 1,
          style: TextStyle(
            fontSize: 14,
            color: ColorConstants.black,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
          enableInteractiveSelection: false,
          autofocus: false,
          keyboardType: widget.textInputType,
          cursorColor: ColorConstants.red,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0),
            filled: true,
            fillColor: ColorConstants.mainAppColor,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.decorated?ColorConstants.darckBlack:ColorConstants.mainAppColor,
                )) ,
            border: OutlineInputBorder(
                borderSide: BorderSide(color:   widget.decorated?ColorConstants.darckBlack:ColorConstants.mainAppColor,)),
            enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(color:   widget.decorated?ColorConstants.darckBlack:ColorConstants.mainAppColor,)),
            contentPadding: EdgeInsets.only(left:10),
            hintText: widget.label,
            suffixIcon: Icon(
              Icons.create,
              color: ColorConstants.darkGray,
              size: 16,
            ),
          ),
          controller: widget._controller,
          validator: validateEmail,

          onChanged:  ((x)=>{ widget.value.value = x,}),

        ),);

    }



}

