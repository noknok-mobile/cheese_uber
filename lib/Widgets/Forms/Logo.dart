import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';

import 'Forms.dart';

class Logo extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const Logo({Key key, this.height = 200}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        Center(
          child: Container(

            height: height/4,
            decoration: BoxDecoration(
                color: ColorConstants.red,
                border: Border(
                    top: BorderSide(width: 1.5),
                    bottom: BorderSide(width: 1.5))
            ),
          ),
        ),
        Center(child: Image(image:AssetsConstants.logo,height: height,)),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
