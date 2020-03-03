import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Buttons/CustomCheckBox.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';

import 'SelectShop.dart';

class ChangeCity extends StatefulWidget {
  final double itemHeight = 40.0;
  bool itsMyCity = true;
  @override
  State<StatefulWidget> createState() => _StateChangeCity();
}
class _StateChangeCity extends State<ChangeCity>{
  @override
  Widget build(BuildContext context) {

    var itemsToDisplay =  Resources().getAllCity;
    String sectedCity = "";
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: SafeArea(
          child:     Center(
            child: FutureBuilder(
              future:  Resources().getNearestShop(),
              builder: (context,  projectSnap){

                if(projectSnap.hasError){
                  print('project snapshot data is: ${projectSnap.data}');
                  // return Container();
                  sectedCity = itemsToDisplay.first;
                } else{
                  sectedCity = projectSnap.data.city;
                }
                if (projectSnap.connectionState != ConnectionState.done){
                  return CircularProgressIndicator();
                }
                if(widget.itsMyCity)
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                       // direction: Axis.vertical,
                        children: <Widget>[
                          CustomText.black18pxBold("${TextConstants.yourCity} $sectedCity ?"),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,18,0,0),
                            child: CustomButton.colored(expanded: true, color:ColorConstants.black,height: 40,child:CustomText.white12px(TextConstants.btnChange),onClick: ()=>{

                              setState(()=>{widget.itsMyCity = false,})
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,18,0,0),
                            child: CustomButton.colored(expanded: true, color:ColorConstants.red,height: 40,child:CustomText.white12px(TextConstants.btnYes),onClick: ()=>{
                              Navigator.push(
                                context,
                                MaterialPageRoute( builder: (context) => SelectShop(selectedCity: sectedCity,)),)}),
                          ),

                        ],
                      ),
                    ),
                  );
               else
                return Column(
                  children: <Widget>[
                    Container(
                        height: widget.itemHeight*itemsToDisplay.length + itemsToDisplay.length+1,
                        margin: EdgeInsets.all(20),

                        decoration:  ParametersConstants.BoxShadowDecoration,
                        child:  ListView.separated(
                          physics:NeverScrollableScrollPhysics(),
                          itemCount: itemsToDisplay.length,
                          separatorBuilder: (buildContext, index) => Container(
                            height: 1,
                            color: ColorConstants.gray,
                          ),
                          itemBuilder: (buildContext, index) => Container(
                              height: widget.itemHeight,
                              child:AutoUpdatingWidget<CitySelected>(
                                child:(context,data){
                                  if(data != null)
                                    sectedCity = data.city;
                                  return CustomCheckBox(
                                      enabledWidget: Container(padding: EdgeInsets.all(10), alignment: Alignment.centerLeft,   child: Row(
                                        children: <Widget>[
                                          CustomText.black16px(itemsToDisplay[index]),
                                          Expanded(child:Container()),
                                          AssetsConstants.iconCheckBox,
                                        ],
                                      )),
                                      disabledWidget:  Container(padding: EdgeInsets.all(10), alignment: Alignment.centerLeft,   child: Row(
                                        children: <Widget>[
                                          CustomText.black16px(itemsToDisplay[index]),
                                          Expanded(child:Container()),
                                        ],
                                      )),  value: itemsToDisplay[index] == sectedCity,onChanged: (x)=>{Resources().selectCity(itemsToDisplay[index])});
                                },
                              )

                          ),
                        )),
                    Expanded(child:Container()),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: CustomButton.colored(expanded: true, color:ColorConstants.red,height: 40,child:CustomText.white12px(TextConstants.btnNext),onClick: ()=>{
                        Navigator.push(
                          context,
                          MaterialPageRoute( builder: (context) => SelectShop(selectedCity: sectedCity,)),)}),
                    )

                  ],
                );

              },

            ),
          )
      ),
    );
  }



}

