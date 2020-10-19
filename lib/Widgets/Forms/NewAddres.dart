import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldCheckBox.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldPhone.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldText.dart';
import 'package:flutter_cheez/Widgets/Pages/SelectAddres.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';


import 'InputFieldAddres.dart';
import 'InputFieldName.dart';

class NewAddres extends StatelessWidget {
  UserAddress userAddress;
  SharedValue<String> phone =   SharedValue<String>();
  SharedValue<String> address =   SharedValue<String>();
  SharedValue<String> name =   SharedValue<String>();
  SharedValue<String> contactName =   SharedValue<String>();
  SharedValue<String> entrance =   SharedValue<String>();
  SharedValue<String> floor =   SharedValue<String>();
  SharedValue<String> flat =   SharedValue<String>();
  SharedValue<String> comment =   SharedValue<String>();
  SharedValue<bool> defaultAddress =    SharedValue<bool>(value: true);
  final formKey = GlobalKey<FormState>();

  NewAddres({Key key, this.userAddress}) : super(key: key){
    if(userAddress == null)
      userAddress = UserAddress(phone: Resources().userProfile.phone,name: "Новый профиль",username: Resources().userProfile.username);
    phone.value = userAddress?.phone;
    address.value= userAddress?.addres;
    name.value= userAddress?.name;
    contactName.value = userAddress?.username;
    entrance.value  = userAddress?.entrance;
    floor.value  = userAddress?.floor;
    flat.value  = userAddress?.flat;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          autovalidateMode:  AutovalidateMode.disabled,
          child: Wrap(
          spacing: 0, // to apply margin horizontally
          runSpacing: 20, // to apply margin vertically
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title:CustomText.black20px(TextConstants.newAddres) ,
                  leading: Material(
                    color: Colors.transparent,
                    child: InkWell(

                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: IconConstants.arrowBack // the arrow back icon
                    ),
                  )),
              InputFieldName(label: TextConstants.addresName,value:name),

            Row(
                children: <Widget>[
                  Expanded(
                    child: InputFieldAddres(
                      label: TextConstants.adres,
                      latitude: Resources().geolocation.latitude,
                      longitude: Resources().geolocation.longitude,
                      value: address,
                    ),
                  ),
                /*  SizedBox(width: 10,),
                  CustomButton.colored(
                    width: 100,
                    height: 40,
                    color: ColorConstants.red,
                    child: CustomText.white12px(TextConstants.onMap),
                    onClick: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder:(context){ return  SelectAddres();}));
                    },
                  ),*/
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child:  InputFieldText(
                    label: TextConstants.addresEntrance,
                    textInputType:TextInputType.number,
                    value:entrance,

                  ),),
                  Expanded(child:  InputFieldText(
                    label: TextConstants.addresFloor,
                    textInputType:TextInputType.number,
                    value:floor
                  ),),
                  Expanded(child:  InputFieldText(
                    label: TextConstants.addresFlat,
                    textInputType:TextInputType.number,
                    value:flat
                  ),),
                ],
              ),
              InputFieldPhone(
                  label: TextConstants.phone,
                  value:phone
              ),
              InputFieldText(
                label: TextConstants.contactName,
                value:contactName
              ),
               InputFieldText(
                height: 90,
                maxLines: 5,
                label: "Комментарий",
                 value: comment,
              ),

              InputFieldCheckBox(label: TextConstants.defaultAddres,state: defaultAddress, ),
              CustomButton.colored(
               width: 9999,
                height: 40,
                color: ColorConstants.red,
                child: CustomText.white12px(TextConstants.btnYes.toUpperCase()),
                onClick: () {
                  if(userAddress != null){
                    userAddress.phone = phone.value;
                    userAddress.addres = address.value;
                    userAddress.name = name.value;
                    userAddress.username = contactName.value;

                    userAddress.flat = flat.value;
                    userAddress.floor = floor.value;
                    userAddress.entrance = entrance.value;

                    Resources().editAddrese(userAddress);
                    Navigator.of(context).pop();
                  } else{
                  }

                  //Navigator.of(context).push(new MaterialPageRoute(builder:(context){ return  SelectAddres();}));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
