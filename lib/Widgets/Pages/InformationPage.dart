import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Widgets/Drawers/LeftMenu.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';
import 'package:flutter_cheez/Widgets/Pages/WebPage.dart';

class InformationPage extends StatelessWidget {
  double _itemHeight = 40;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: ColorConstants.background,
      drawer: Drawer(child: LeftMenu()),
      appBar: NextPageAppBar(
          height: ParametersConstants.appBarHeight,
          title: TextConstants.infoHeader),
      body: Container(
        decoration: ParametersConstants.BoxShadowDecoration,
        //height: _itemHeight*TextConstants.informationHeader.length + (TextConstants.informationHeader.length+1.0),
        margin: EdgeInsets.all(20),
        child: ListView.builder(

            itemCount: TextConstants.informationHeader.length,
            itemBuilder: (context, index) => Container(
                height: _itemHeight+9,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                         Expanded(flex:7, child: CustomText.black16px(
                              TextConstants.informationHeader[index].item1,maxLines:1),),
                          Expanded(flex:1,child: Container(alignment: Alignment.centerRight, child: IconConstants.arrowFront,),),

                        ],
                      ),
                      onPressed: () => { Navigator.push(
                        context,
                        MaterialPageRoute( builder: (context) => WebPage(title: TextConstants.informationHeader[index].item1,url:TextConstants.informationHeader[index].item2)),)},
                    ),
                    Container(
                      height: 1,
                      color: ColorConstants.background,
                    ),
                  ],
                ))
        ),
      ),
    );
  }
}
