import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/CountButtonGroup.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Pages/DetailGoods.dart';
import 'Forms.dart';

class Goods extends StatelessWidget implements PreferredSizeWidget{
  Goods({Key key, this.data, this.height}) : super(key: key);
  final double height;
  final GoodsData data;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    bool showInfo = height>150;
    bool oneLine = query.size.width > 380;
    print(query.size.width);
    double padding = 12 * (oneLine ? 1.0 : 0.5 );

    return FlatButton(
      child: Container(
        height: height ,

          padding: EdgeInsets.fromLTRB(padding, padding , padding , padding ),
          decoration: BoxDecoration(
            color: ColorConstants.mainAppColor,
            borderRadius:
            BorderRadius.circular(ParametersConstants.largeImageBorderRadius),
            border:
            Border.all(color: ColorConstants.goodsBorder.withOpacity(0.1)),
            boxShadow: [
              ParametersConstants.shadowDecoration,
            ],
          ),
          child: LayoutBuilder(
            builder: (context, snapshot) {
              if(oneLine){
                return _buildOneLine(context,showInfo: showInfo);
              } else {

                return _buildTooLine(context,showInfo: showInfo);
              }
            }
          )
      ),
      onPressed:(){
        Navigator.of(context).push(new MaterialPageRoute(builder:(context){ return  DetailGoods(goodsData: data,);}));
      }
    );
  }
  Widget _buildTooLine(BuildContext context,{bool showInfo = true,double padding = 6}){
    var query = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Center(child: CachedImage.imageForShopList(url: data.imageUrl,height: (preferredSize.height*query.size.width/query.size.height - padding*2))),

              Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(padding, 0, 0, 0),
                    //width: c_width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            data.name,
                            style: Theme.of(context).textTheme.body1,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          showInfo ?   Padding(
                            padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                            child: Text(
                              data.info,
                              style: Theme.of(context).textTheme.body2,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ) : Container(),

                        ]),
                  ))
            ]),

        Flexible(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, padding, 0, 0),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: "${data.price.toInt().toString()} р \n",
                          style: Theme.of(context).textTheme.subtitle,

                          children: <TextSpan>[
                            TextSpan(text: "${data.units.contains(TextConstants.units) ?"1 "+data.units :"100 "+data.units}",
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      AutoUpdatingWidget<CartUpdated>(
                        child:(context)=> CountButtonGroup(
                          getText: (){return "${data.units.contains(TextConstants.units) ? Resources().cart.getCount(data.id): Resources().cart.getCount(data.id)*100} ${data.units}";},
                          setCount: (int count)=>{  Resources().cart.setCount(data.id,data.units.contains(TextConstants.units) ? count: count == 1 ? 3 : count < 3 ? 0 : count  )},
                          getCount: (){ return Resources().cart.getCount(data.id);},
                        ),
                      )
                    ]),
              )),
        )
      ],
    );
  }
  Widget _buildOneLine(BuildContext context,{bool showInfo = true,double padding = 12}){
    var query = MediaQuery.of(context);
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Center(child: CachedImage.imageForShopList(url: data.imageUrl,height:preferredSize.height - padding*2)),

          Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.fromLTRB(padding, 0, 0, 0),
                //width: c_width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.name,
                        style: Theme.of(context).textTheme.body1,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),

                    showInfo ? Padding(
                       padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                       child: Text(

                         data.info,
                         style: Theme.of(context).textTheme.body2,
                         maxLines: 2,
                         softWrap: true,
                         overflow: TextOverflow.ellipsis,
                         textAlign: TextAlign.left,
                       ),
                     ) : Container(),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: "${data.price.toInt().toString()} р \n",
                                      style: Theme.of(context).textTheme.subtitle,

                                      children: <TextSpan>[
                                        TextSpan(text: "${data.units.contains(TextConstants.units) ?"1 "+data.units :"100 "+data.units}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  AutoUpdatingWidget<CartUpdated>(

                                    child:(context,e)=> CountButtonGroup(
                                      getText: (){return "${data.units.contains(TextConstants.units) ? Resources().cart.getCount(data.id): Resources().cart.getCount(data.id)*100} ${data.units}";},
                                      setCount: (int count)=>{  Resources().cart.setCount(data.id,data.units.contains(TextConstants.units) ? count: count == 1 ? 3 : count < 3 ? 0 : count  )},
                                      getCount: (){ return Resources().cart.getCount(data.id);},
                                    ),
                                  )
                                ]),
                          ))
                    ]),
              ))
        ]);
  }

}
