import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Utils/NetworkUtil.dart';

class CategoryWidget extends StatelessWidget {
  String title;
  String image;

  CategoryWidget({
    Key key,
    @required this.title,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
              ParametersConstants.largeImageBorderRadius)),
      child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                    child: CachedNetworkImage(
                  height: 100.0,
                  imageUrl: image != "" ? image : NetworkUtil.defauilPicture,
                  placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        color: ColorConstants.mainAppColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(child: CircularProgressIndicator())),
                )),
              ),
              Expanded(
                  flex: 6,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),
                      )))
            ],
          )),
    );
  }
}
