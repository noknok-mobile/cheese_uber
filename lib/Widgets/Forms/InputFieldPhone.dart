import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldText.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'CustomInputField.dart';
import 'Forms.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
class InputFieldPhone extends StatefulWidget {

  final String label;
  final String prefix;
  final SharedValue<String> value;
  final bool decorated;
  final double height;
  final _mobileFormatter = new MaskedTextController(mask: '+7 (000) 00 00 000');

  InputFieldPhone({Key key,this.value,this.label ="Телефон",this.height = 45,this.decorated = true,this.prefix = ""}) : super(key: key){

    _mobileFormatter.text = value?.value;
  }



  @override
  _InputFieldPhoneState createState() => _InputFieldPhoneState();
}
class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('+7');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 3) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 6) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + '');
      if (newValue.selection.end >= 14) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}


class _InputFieldPhoneState extends State<InputFieldPhone> {

  List<String> suggestions = List<String>();


  String response = '';
  String currentText;

  String validateText(String value){
    String trimmedText = value.replaceAll(' ', '').replaceAll('+', '').replaceAll('(', '').replaceAll(')', '');
    Pattern pattern =
     '[0-9]';
    RegExp regex = new RegExp(pattern);
    if(trimmedText.length != 11 || !regex.hasMatch(trimmedText)){
      return "Не верный номер телефона";
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    var textField = TextFormField(
        controller:widget._mobileFormatter,
        style:   TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.w500,),
        keyboardType: TextInputType.phone,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          prefixText:widget.prefix!=""? widget. prefix+": ":"",
          filled: true,
          errorStyle: TextStyle(height: 0),
          fillColor: ColorConstants.mainAppColor,
          focusedBorder:widget.decorated? OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.darckBlack,
              )):InputBorder.none,
          border:widget.decorated?OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.darckBlack)):InputBorder.none,
          enabledBorder: widget.decorated?OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.darckBlack)):InputBorder.none,

          contentPadding: EdgeInsets.only(left: 10,bottom: 20),
          hintText: widget.label,
          suffixIcon: Icon(
            Icons.create,
            color: ColorConstants.darkGray,
            size: 16,
          ),

        ),
      validator: validateText,
      onChanged: (String value) => {
        widget._mobileFormatter.moveCursorToEnd(),
        widget.value.value = widget._mobileFormatter.text
      },
        //controller: queryController,
      );

    return Container(height: widget.height, child: textField);
  }


}
