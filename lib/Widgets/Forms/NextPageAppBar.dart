import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';

class NextPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final PreferredSizeWidget bottom;
  final bool needToBeReloaded;
  const NextPageAppBar(
      {Key key,
      @required this.height ,
      this.title,
      this.bottom,
      this.needToBeReloaded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: ColorConstants.mainAppColor,
            //borderRadius: BorderRadius.circular(ParametersConstants.largeImageBorderRadius),
            // border: Border.all(color: ColorConstants.goodsBorder),
            boxShadow: [ParametersConstants.shadowDecoration]),
        child: Column(
          children: [
            Container(
              color: ColorConstants.mainAppColor,
              child: SafeArea(
                child: Container(
                  height: height,
                  child: Row(children: [
                    IconButton(
                      icon: IconConstants.arrow_back,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
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
