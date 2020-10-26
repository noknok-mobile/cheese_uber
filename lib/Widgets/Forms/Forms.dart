import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Utils/NetworkUtil.dart';
import 'package:html/parser.dart';

class Label extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class PriceText extends StatelessWidget {
  final GoodsData goodsData;

  const PriceText({Key key, this.goodsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "${(goodsData.getPrice().price + 0.4).round().toString()} р \n",
        style: Theme.of(context).textTheme.subtitle2,
        children: <TextSpan>[
          TextSpan(
              text:
                  "${goodsData.units.contains(TextConstants.units) ? "1 " + goodsData.units : "1 " + goodsData.units}",
              style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final TextStyle style;
  final TextAlign align;
  final String content;
  final int maxLines;
  const CustomText(this.content,
      {Key key, this.style, this.align = TextAlign.left, this.maxLines = 1})
      : super(key: key);
  const CustomText.white12px(this.content,
      {Key key,
      this.style = const TextStyle(
        fontSize: 12,
        color: ColorConstants.mainAppColor,
        fontWeight: FontWeight.w400,
      ),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.white14px(this.content,
      {Key key,
      this.style = const TextStyle(
        fontSize: 14,
        color: ColorConstants.mainAppColor,
        fontWeight: FontWeight.w500,
      ),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.gray12px(this.content,
      {Key key,
      this.style = const TextStyle(
        fontSize: 12,
        color: ColorConstants.gray,
        fontWeight: FontWeight.w400,
      ),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.gray14px(this.content,
      {Key key,
      this.style = const TextStyle(
        fontSize: 14,
        color: ColorConstants.gray,
        fontWeight: FontWeight.w400,
      ),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.gray16px(this.content,
      {Key key,
      this.style = const TextStyle(
        fontSize: 16,
        color: ColorConstants.gray,
        fontWeight: FontWeight.w400,
      ),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.darkGray16px(this.content,
      {Key key,
      this.style = const TextStyle(
        fontSize: 16,
        color: ColorConstants.darkGray,
        fontWeight: FontWeight.w400,
      ),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.darkGray14px(this.content,
      {Key key,
      this.style = const TextStyle(
        fontSize: 14,
        color: ColorConstants.darkGray,
        fontWeight: FontWeight.w400,
      ),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.black12px(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 12,
          color: ColorConstants.black,
          fontWeight: FontWeight.w400),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.black12pxUnderline(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 12,
          color: ColorConstants.black,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.black14px(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 14,
          color: ColorConstants.black,
          fontWeight: FontWeight.w400),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.black16px(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 16,
          color: ColorConstants.black,
          fontWeight: FontWeight.w400),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.black18px(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 18,
          color: ColorConstants.black,
          fontWeight: FontWeight.w400),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.black20px(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 20,
          color: ColorConstants.black,
          fontWeight: FontWeight.w400),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.black24px(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 24,
          color: ColorConstants.black,
          fontWeight: FontWeight.w500),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.black18pxBold(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 18,
          color: ColorConstants.black,
          fontWeight: FontWeight.w800),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.black20pxBold(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 20,
          color: ColorConstants.black,
          fontWeight: FontWeight.w800),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.red14pxUnderline(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 14,
          color: ColorConstants.red,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.red24px(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 24, color: ColorConstants.red, fontWeight: FontWeight.w800),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.red14px(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 14, color: ColorConstants.red, fontWeight: FontWeight.w800),
      this.align = TextAlign.left,
      this.maxLines = 10})
      : super(key: key);
  const CustomText.white24px(this.content,
      {Key key,
      this.style = const TextStyle(
          fontSize: 24,
          color: ColorConstants.mainAppColor,
          fontWeight: FontWeight.w400),
      this.align = TextAlign.left,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      parse(content).documentElement.text,
      style: style,
      softWrap: true,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
    );
  }
}

class CachedImage extends StatelessWidget implements PreferredSizeWidget {
  final String url;
  final Color backgroundColor;
  final Widget child;
  final bool roundBorder;
  double width;
  double height;
  double radius;

  CachedImage(
      {Key key,
      this.url,
      this.child,
      this.width,
      this.height,
      this.radius = 7,
      this.backgroundColor = ColorConstants.mainAppColor,
      this.roundBorder = true})
      : super(key: key);

  CachedImage.imageForCart(double sizeMultipler,
      {Key key,
      this.url,
      this.child,
      this.height,
      this.backgroundColor = ColorConstants.mainAppColor,
      this.roundBorder = true})
      : super(key: key) {
    width = ParametersConstants.smallImageWidth * sizeMultipler;
    height = ParametersConstants.smallImageHeight * sizeMultipler;
    radius = ParametersConstants.smallImageBorderRadius;
  }

  CachedImage.imageForShopList(
      {Key key,
      this.url,
      this.child,
      this.height,
      this.backgroundColor = ColorConstants.mainAppColor,
      this.roundBorder = true})
      : super(key: key) {
    width = height;
    height = height;
    radius = ParametersConstants.mediumImageBorderRadius;
  }
  CachedImage.imageForCategory(
      {Key key,
      this.url,
      this.child,
      this.backgroundColor = ColorConstants.mainAppColor,
      this.roundBorder = true})
      : super(key: key) {
    width = ParametersConstants.largeImageWidth;
    height = ParametersConstants.largeImageHeight;
    radius = ParametersConstants.largeImageBorderRadius;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CachedNetworkImage(
      color: backgroundColor,
      imageUrl: url.isEmpty ? NetworkUtil.defauilPicture : url,
      imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(roundBorder ? radius : 0),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,

              // colorFilter: ColorFilter.mode(Colors.blue, BlendMode.colorBurn)
            ),
          ),
          child: child),
      placeholder: (context, url) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: backgroundColor,
          ),
          child: child),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(width, height);
}
