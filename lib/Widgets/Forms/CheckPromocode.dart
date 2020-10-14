
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'Forms.dart';
import 'InputFieldText.dart';

class CheckPromocode extends StatefulWidget{
  var inProgress = false;
  var errorMessage = "";
  SharedValue<String> promocode ;
  CheckPromocode({
    Key key,
    this.promocode,
  }) : super(key: key);


@override
State<StatefulWidget> createState() =>_checkPromocodeState();




}

class _checkPromocodeState extends State<CheckPromocode>{
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ParametersConstants.largeImageBorderRadius),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      // shape:  ShapeBorder().,
      children: <Widget>[
        Container(
          decoration:BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(ParametersConstants.largeImageBorderRadius)) ) ,
          height: 135  ,
          child: Form(
            key: _formKey,
            child: Column(

              children: <Widget>[
                CustomText.black14px("Введите промокод"),
                SizedBox(height: 10,width: 0,),
                widget.errorMessage != ""?CustomText.red14px(widget.errorMessage):Container(),

                InputFieldText(value: widget.promocode,validator: (x){if(x.length < 4) return "Не верный промокод"; else return null;}, ),
                Expanded(child: Container(),),
                SizedBox(height: 10,width: 0,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomButton.colored(
                        color: ColorConstants.black,
                        enable: !widget.inProgress,
                        height: 45,
                        //width: 9999,
                        child: CustomText.white12px("ВСТАВИТЬ"),
                        onClick: (){
                           Clipboard.getData(Clipboard.kTextPlain).then((text) =>{print(text),text!=null?widget.promocode.value = text?.text:widget.promocode.value = '' , setState((){})});
                          widget.errorMessage = "";
                           setState((){});
                        },
                      ),
                    ),
                    SizedBox(height: 10,width: 10,),
                    Expanded(
                      child: CustomButton.colored(
                        color: ColorConstants.red,
                        enable: !widget.inProgress,
                        height: 45,
                      //  width: 9999,
                        child: CustomText.white12px("ОТПРАВИТЬ"),
                        onClick: (){
                          widget.errorMessage = "";

                          if(_formKey.currentState.validate()){

                            setState(() { widget.inProgress = true; });
                            Resources().checkPromo(widget.promocode.value) .then((value) async {
                              if(value == "") {
                                Resources().cart.setPromocode = widget.promocode.value;
                                Navigator.of(context).pop();
                              }else{
                                widget.promocode.value = "";
                                Resources().cart.setPromocode = widget.promocode.value;
                                widget.errorMessage = value;
                                setState(() {
                                  widget.inProgress = false;
                                });
                              }
                              return;
                            });


                          } else {

                           //setState(() {
                          //    widget.inProgress = false;
                          //  });
                          }

                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


}




