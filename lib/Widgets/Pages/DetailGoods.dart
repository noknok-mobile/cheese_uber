import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Forms/DetailGoodsBottomAppBar.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'dart:math' as math;

class DetailGoods extends StatelessWidget {
  final GoodsData goodsData;

  const DetailGoods({Key key, this.goodsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.topCenter,
              child: FutureBuilder(
                future: Resources().getCategoryById(
                    goodsData.categories.firstWhere((x) => x != null)),
                builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return CachedImage.imageForCategory(
                      url: snapshot.data.imageUrl,
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )),
          SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: Row(children: <Widget>[
                    //SizedBox(width: 20,height: 0,),
                    Transform.rotate(
                      angle: math.pi / 2,
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: ColorConstants.mainAppColor,
                          size: 30,
                        ),
                        onPressed: () => {Navigator.of(context).pop()},
                      ),
                    ),
                    //SizedBox(width: 30,height: 0,),
                    CustomText.white24px(TextConstants.detailsHeader),
                  ]),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: ColorConstants.mainAppColor,
                      borderRadius: BorderRadius.circular(
                          ParametersConstants.largeImageBorderRadius),
                      border: Border.all(
                          color: ColorConstants.goodsBorder.withOpacity(0.1)),
                      boxShadow: [
                        ParametersConstants.shadowDecoration,
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 0, 20, 20.0),
                              child: Center(
                                  child: CachedImage.imageForShopList(
                                url: goodsData.imageUrl,
                                height: 110,
                              )),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CustomText.black16px(goodsData.name),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 17, 0, 0),
                                    child: PriceText(
                                      goodsData: goodsData,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: CustomText.black16px(goodsData.info),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(),
        ],
      ),

      bottomNavigationBar: DetailGoodsBottomAppBar(height: 145,goodItem: goodsData,),
    );
  }
}
