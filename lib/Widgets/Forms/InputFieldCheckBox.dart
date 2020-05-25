import 'package:flutter/cupertino.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Buttons/CustomCheckBox.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';

import 'CustomInputField.dart';

class InputFieldCheckBox extends CustomInputField{

  final String label;
  final EdgeInsetsGeometry padding;
  SharedValue<bool> state;
  InputFieldCheckBox({this.label = "",this.state,this.padding = const EdgeInsets.only(left: 10,right: 10)}){
    content = Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          Expanded(child: CustomText.black16px(label)),

          CustomCheckBox(disabledWidget: AssetsConstants.toggleOff,enabledWidget: AssetsConstants.toggleOn,value: state.value,)
        ],
      ),
    );
  }

  @override
  void onTap(){
    state.value = !state.value;
    content = Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          Expanded(child: CustomText.black16px(label)),

          CustomCheckBox(onChanged: (x){ state.value = x;}, disabledWidget: AssetsConstants.toggleOff,enabledWidget: AssetsConstants.toggleOn,value:  state.value,)
        ],
      ),
    );
  }
}