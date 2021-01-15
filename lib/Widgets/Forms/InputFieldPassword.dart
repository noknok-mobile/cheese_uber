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

class InputFieldPassword extends StatefulWidget {
  final String label;
  final SharedValue<String> value;
  final double height;
  final bool decorated;
  bool showPass = true;
  TextEditingController _controller = new TextEditingController();

  InputFieldPassword(
      {Key key,
      this.value,
      this.label = "Пароль",
      this.height = 45,
      this.decorated = true})
      : super(key: key) {
    _controller.text = value?.value;
  }

  @override
  _InputFieldPasswordState createState() => _InputFieldPasswordState();
}

class _InputFieldPasswordState extends State<InputFieldPassword> {
  List<String> suggestions = List<String>();

  String response = '';
  String currentText;
  String validateText(String value) {
    if (value.length < 6) {
      return "Пароль должен содержать хотябы 6 символов ";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var textField = TextFormField(
      controller: widget._controller,
      //initialValue: widget.value.value,
      /* inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
          _mobileFormatter,
        ],*/
      style: TextStyle(
        fontSize: 14,
        color: ColorConstants.black,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.text,
      cursorColor: ColorConstants.red,
      obscureText: widget.showPass,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        errorStyle: TextStyle(height: 0),
        filled: true,
        fillColor: ColorConstants.mainAppColor,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              color: widget.decorated
                  ? ColorConstants.darckBlack
                  : ColorConstants.mainAppColor,
            )),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              color: widget.decorated
                  ? ColorConstants.darckBlack
                  : ColorConstants.mainAppColor,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              color: widget.decorated
                  ? ColorConstants.darckBlack
                  : ColorConstants.mainAppColor,
            )),
        contentPadding: EdgeInsets.only(left: 10),
        suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                widget.showPass = !widget.showPass;
              });
            },
            child: IconConstants.showPass),
        hintText: widget.label,
      ),
      validator: validateText,
      onChanged: (String value) => {widget.value.value = value},
      //controller: queryController,
    );

    return Container(height: widget.height, child: textField);
  }
}
