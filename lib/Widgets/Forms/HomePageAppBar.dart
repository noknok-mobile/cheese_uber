import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';

class HomePageAppBar extends  StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;

  const HomePageAppBar({
    Key key,
    @required this.height,this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(

          color: ColorConstants.mainAppColor,
          child: SafeArea(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                  color: ColorConstants.mainAppColor,
                  //borderRadius: BorderRadius.circular(ParametersConstants.largeImageBorderRadius),
                 // border: Border.all(color: ColorConstants.goodsBorder),
                  boxShadow: [
                   ParametersConstants.shadowDecoration
                  ]),

              child:Row(children: [
                IconButton(
                  icon: IconConstants.menu,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),

                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Text(
                        title,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline,
                      ),
                    ),
                  ),

                /*
                IconButton(
                  icon: Icon(Icons.verified_user),
                  onPressed: () => null,
                ),*/
              ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}