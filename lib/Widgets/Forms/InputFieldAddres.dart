import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldText.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'CustomInputField.dart';
import 'Forms.dart';

class InputFieldAddres extends StatefulWidget {
  final String label;
  final TextInputType textInputType;
  final double latitude;
  final double longitude;
  final double height;
  final bool decorated;
  final SharedValue<String> value;
  TextEditingController queryController = TextEditingController();
  InputFieldAddres({Key key,
    this.label = "Имя",
    this.textInputType = TextInputType.text, this.latitude = 50, this.longitude = 50, this.height = 40, this.value, this.decorated = true

  }): super(key: key){

    queryController.text = value?.value;
  }


  @override
  _InputFieldAddresState createState() => _InputFieldAddresState();
}


class _InputFieldAddresState extends State<InputFieldAddres> {
  List<String> suggestions = List<String>();


  String response = '';
  String currentText;

  @override
  Widget build(BuildContext context) {

    var textField = SimpleAutoCompleteTextField(

        style:   TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.w500,),
        submitOnSuggestionTap: true,


        minLength:4,
        decoration: InputDecoration(
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
          contentPadding: EdgeInsets.all(10),
          hintText: TextConstants.adres,
          suffixIcon: Icon(
            Icons.create,
            color: ColorConstants.darkGray,
            size: 16,
          ),
        ),
        controller: widget.queryController,
        suggestions: suggestions,
        textChanged: (text) =>{  querySuggestions(text)},
        clearOnSubmit: false,


        textSubmitted: (text) => setState(() {
              if (text != "") {
                widget.value.value = text;
                currentText = text;
               // queryController.text = text;
                //queryController.value = text;
                suggestions.clear();
                print(text);
                //added.add(text);
              }
            }));

    return Container(height: widget.height, child: textField);
  }

  Future<void> querySuggestions(String query) async {
    final CancelSuggestCallback cancelListening =
        await YandexSearch.getSuggestions(
            query,
            Point(latitude:widget.latitude, longitude: widget.longitude),
            Point(latitude:widget.latitude, longitude: widget.longitude),
            'GEO',
            true, (List<SuggestItem> suggestItems) {


          setState(() {
            suggestions.clear();
            suggestItems.forEach((SuggestItem item) => {
              item.tags.forEach((x)=> print(x)),
              item.tags.contains("street") && !suggestions.contains(item.title)
                  ? suggestions.add(item.title)
                  : null
            });
            print("suggestItems "+suggestItems.length.toString());
            print("suggestions "+suggestions.length.toString());
          });
    });
    await Future<dynamic>.delayed(
        const Duration(seconds: 3), () => cancelListening());
  }
}
