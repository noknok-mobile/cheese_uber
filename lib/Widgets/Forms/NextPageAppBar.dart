import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';

class NextPageAppBar  extends  StatelessWidget implements PreferredSizeWidget{
  final double height;
  final String title;
  final PreferredSizeWidget bottom;
  const NextPageAppBar({
    Key key,
    @required this.height, this.title, this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

        decoration: BoxDecoration(
            color: ColorConstants.mainAppColor,
            //borderRadius: BorderRadius.circular(ParametersConstants.largeImageBorderRadius),
            // border: Border.all(color: ColorConstants.goodsBorder),
            boxShadow: [
              ParametersConstants.shadowDecoration
            ]),
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
                    Text(
                        title,
                        style: Theme
                        .of(context)
                        .textTheme
                        .headline,
                    )

                 // ) ,

                ),

            ]),
          ),
        ),
        ),
        bottom,
      ],
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(height+bottom.preferredSize.height);
}