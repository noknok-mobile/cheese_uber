import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';

class NextPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final PreferredSizeWidget bottom;

  const NextPageAppBar(
      {Key key, this.height =  65,
      this.title = "",
      this.bottom,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: ColorConstants.mainAppColor,

            boxShadow: [ParametersConstants.shadowDecoration]),
        child: Column(
          children: [
            Container(
              color: ColorConstants.mainAppColor,
              child: SafeArea(
                child: Container(
                  height: height,
                  child: Row(children: [
                    title != "" ? IconButton(
                      icon: IconConstants.arrowBack,
                      onPressed: () {
                        var route = ModalRoute.of(context);
                        if (route.settings.name == "/cart") {
                          Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute( builder: (context) => CategoryPage()), (Route<dynamic> route) => false);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ):Container(),
                    Container(width: 10,),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: //Expanded(
                            CustomText.black24px(
                          title,

                        )),
                  ]),
                ),
              ),
            ),
            bottom != null ? bottom : SizedBox(),
          ],
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(
      height + (bottom == null ? 0 : bottom.preferredSize.height));
}
