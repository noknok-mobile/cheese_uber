import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';

class Label extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
class PriceText extends StatelessWidget {

  final GoodsData goodsData;

  const PriceText({Key key,  this.goodsData}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  RichText(
      text: TextSpan(
        text: "${goodsData.price.toInt().toString()} р \n",
        style: Theme.of(context).textTheme.subtitle,

        children: <TextSpan>[

          TextSpan(text: "${goodsData.units.contains(TextConstants.units) ?"1 "+goodsData.units :"100 "+goodsData.units}",
              style: Theme.of(context)
                  .textTheme
                  .body2
          ),
        ],
      ),
    );
  }
}
class CustomText extends StatelessWidget {
  final TextStyle style;
  final String content;

  const CustomText(this.content,{Key key, this.style}) : super(key: key);
  const CustomText.white12px(this.content,{Key key,this.style = const TextStyle(fontSize: 14,color:ColorConstants.mainAppColor,fontWeight: FontWeight.w400)}) : super(key: key);
  const CustomText.black14px(this.content,{Key key, this.style = const TextStyle(fontSize: 14,color:ColorConstants.black,fontWeight: FontWeight.w400)}) : super(key: key);
  const CustomText.black16px(this.content,{Key key, this.style = const TextStyle(fontSize: 16,color:ColorConstants.black,fontWeight: FontWeight.w400)}) : super(key: key);
  const CustomText.black18px(this.content,{Key key, this.style = const TextStyle(fontSize: 18,color:ColorConstants.black,fontWeight: FontWeight.w400)}) : super(key: key);
  const CustomText.black20px(this.content,{Key key, this.style = const TextStyle(fontSize: 20,color:ColorConstants.black,fontWeight: FontWeight.w400)}) : super(key: key);
  const CustomText.black24px(this.content,{Key key, this.style = const TextStyle(fontSize: 24,color:ColorConstants.black,fontWeight: FontWeight.w500)}) : super(key: key);
  const CustomText.black18pxBold(this.content,{Key key, this.style = const TextStyle(fontSize: 18,color:ColorConstants.black,fontWeight: FontWeight.w800)}) : super(key: key);
  const CustomText.red14pxUnderline(this.content,{Key key,this.style = const TextStyle(fontSize: 14,color:ColorConstants.red,fontWeight: FontWeight.w500,decoration:  TextDecoration.underline)}) : super(key: key);
  const CustomText.red24px(this.content,{Key key,this.style = const TextStyle(fontSize: 24,color:ColorConstants.red,fontWeight: FontWeight.w800)}) : super(key: key);

  const CustomText.white24px(this.content,{Key key,this.style = const TextStyle(fontSize: 24,color:ColorConstants.mainAppColor,fontWeight: FontWeight.w500)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(content,style:style,
      softWrap: true,
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,);
  }
}


class CachedImage extends StatelessWidget implements PreferredSizeWidget{
  final String url;
  final Widget child;
  double width;
  double height;
  double radius;

  CachedImage({Key key, this.url, this.child, this.width, this.height, this.radius}) : super(key: key);

  CachedImage.imageForCart(double sizeMultipler, {Key key, this.url,this.child,this.height}): super(key: key){

    width =  ParametersConstants.smallImageWidth*sizeMultipler;
    height = ParametersConstants.smallImageHeight*sizeMultipler;
    radius = ParametersConstants.smallImageBorderRadius;
  }
  CachedImage.imageForShopList({Key key, this.url,this.child,this.height}): super(key: key){
    width =  height;
    height = height;
    radius = ParametersConstants.mediumImageBorderRadius;
  }
  CachedImage.imageForCategory({Key key, this.url,this.child}): super(key: key){
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


