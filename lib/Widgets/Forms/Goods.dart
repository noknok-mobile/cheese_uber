
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/CountButtonGroup.dart';
import 'Forms.dart';
import 'package:webview_flutter/webview_flutter.dart';
class Goods extends StatelessWidget {
  Goods({Key key, this.data,}) : super(key: key);
  final GoodsData data;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 3,0, 3),
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
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
              if(snapshot.maxWidth < 320){
                return _buildTooLine(context);
              } else {

                return _buildOneLine(context);
              }
            }
          )
      ),
      onPressed:(){ Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return null;
      }));
      }
    );
  }
  Widget _buildTooLine(BuildContext context){
    var query = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Center(child: CachedImage.imageForShopList(query.size.width/query.size.height, url: data.imageUrl)),

              Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                            child: Text(
                              data.info,
                              style: Theme.of(context).textTheme.body2,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),

                        ]),
                  ))
            ]),

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
                          TextSpan(text: "${data.units == "шт" ?"1 "+data.units :"100 "+data.units}",
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    CountButtonGroup(
                      getText: (){return "${data.units == "шт" ? Resources().cart.getCount(data.id): Resources().cart.getCount(data.id)*100} ${data.units}.";},
                      setCount: (int count)=>{  Resources().cart.setCount(data.id,data.units == "шт" ? count: count == 1 ? 3 : count < 3 ? 0 : count  )},
                      getCount: (){ return Resources().cart.getCount(data.id);},
                    )
                  ]),
            ))
      ],
    );
  }
  Widget _buildOneLine(BuildContext context){
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Center(child: CachedImage.imageForShopList(1, url: data.imageUrl)),

          Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                        child: Text(
                          data.info,
                          style: Theme.of(context).textTheme.body2,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
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
                                        TextSpan(text: "${data.units == "шт" ?"1 "+data.units :"100 "+data.units}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  CountButtonGroup(
                                    getText: (){return "${data.units == "шт" ? Resources().cart.getCount(data.id): Resources().cart.getCount(data.id)*100} ${data.units}.";},
                                    setCount: (int count)=>{  Resources().cart.setCount(data.id,data.units == "шт" ? count: count == 1 ? 3 : count < 3 ? 0 : count  )},
                                    getCount: (){ return Resources().cart.getCount(data.id);},
                                  )
                                ]),
                          ))
                    ]),
              ))
        ]);
  }
}
