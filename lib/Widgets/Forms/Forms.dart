import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_cheez/Resources/Constants.dart';

class Label extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }




}
class CustomText extends StatelessWidget {
  final TextStyle style;
  final String content;
  const CustomText(this.content,{Key key, this.style}) : super(key: key);

  const CustomText.white12px(this.content,{Key key,this.style = const TextStyle(fontSize: 14,color:ColorConstants.mainAppColor,fontWeight: FontWeight.w400)}) : super(key: key);
  const CustomText.black14px(this.content,{Key key, this.style = const TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.w400)}) : super(key: key);
  const CustomText.black18px(this.content,{Key key, this.style = const TextStyle(fontSize: 18,color:ColorConstants.black,fontWeight: FontWeight.w400)}) : super(key: key);
  const CustomText.red24px(this.content,{Key key,this.style = const TextStyle(fontSize: 24,color:ColorConstants.red,fontWeight: FontWeight.w800)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(content,style:style,);
  }



}


class CachedImage extends StatelessWidget implements PreferredSizeWidget{
  String url;
  Widget child;
  double width;
  double height;
  double radius;

  CachedImage({Key key, this.url, this.child, this.width, this.height, this.radius}) : super(key: key);

  CachedImage.imageForCart(double sizeMultipler, {Key key, this.url,this.child,this.height}){

    width =  ParametersConstants.smallImageWidth*sizeMultipler;
    height = ParametersConstants.smallImageHeight*sizeMultipler;
    radius = ParametersConstants.smallImageBorderRadius;
  }
  CachedImage.imageForShopList({Key key, this.url,this.child,this.height}){
    width =  height;
    height = height;
    radius = ParametersConstants.mediumImageBorderRadius;
  }
  CachedImage.imageForCategory({Key key, this.url,this.child}){
    width =  ParametersConstants.largeImageWidth;
    height = ParametersConstants.largeImageHeight;
    radius = ParametersConstants.largeImageBorderRadius;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CachedNetworkImage(
      imageUrl:url,
      imageBuilder: (context, imageProvider) => Container(

          width: width,
          height: height,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(radius),
            color:ColorConstants.gray,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              // colorFilter: ColorFilter.mode(Colors.blue, BlendMode.colorBurn)
            ),


          ),
          child:child
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(width,height);
}


