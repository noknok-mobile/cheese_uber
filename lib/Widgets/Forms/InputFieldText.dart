

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Buttons/CustomCheckBox.dart';

import 'CustomInputField.dart';
import 'Forms.dart';

class InputFieldText extends CustomInputField {
  final String label;
  final String prefix;
  final TextInputType textInputType;
  final double height;
  final SharedValue<String> value;
  final int maxLines;
  final bool decorated;
  TextEditingController _controller = new TextEditingController();
  var validator = (x){return null;};

  InputFieldText(
      {this.label = "",
        this.prefix = "",
      this.textInputType = TextInputType.multiline,
      this.height = 35,
      this.value,
        this.validator,
        this.maxLines = 1,
        this.decorated = true
      }) {

    _controller.text = value?.value;
    content = Container(
      alignment: Alignment.center,
      height: height,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
       // expands: true,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 14,
          color: ColorConstants.black,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
        enableInteractiveSelection: false,
        autofocus: false,
        keyboardType: textInputType,
        cursorColor: ColorConstants.red,
        decoration: InputDecoration(
          prefixText:prefix!=""?  prefix+": ":"",
          errorStyle: TextStyle(height: 0),
          filled: true,
          fillColor: ColorConstants.mainAppColor,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: decorated?ColorConstants.darckBlack:ColorConstants.mainAppColor,
          )) ,
          border: OutlineInputBorder(
              borderSide: BorderSide(color:  decorated?ColorConstants.darckBlack:ColorConstants.mainAppColor,)),
          enabledBorder:  OutlineInputBorder(
              borderSide: BorderSide(color:  decorated?ColorConstants.darckBlack:ColorConstants.mainAppColor,)),
          contentPadding: EdgeInsets.fromLTRB(10,10,0,10),
          hintText: label,
          suffixIcon: Icon(
            Icons.create,
            color: ColorConstants.darkGray,
            size: 16,
          ),
        ),
        validator: validator,
        controller: _controller,
        onChanged: (String value) => {
          this.value.value = value
        },
      ),
    );
  }

  @override
  void onTap() {
    content = Row(
      children: <Widget>[
        Expanded(child: CustomText.black16px(label)),
        Icon(
          Icons.create,
          color: ColorConstants.darkGray,
        ),
      ],
    );
  }

}
