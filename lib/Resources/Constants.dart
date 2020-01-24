import 'package:flutter/material.dart';
class TextConstants{
  static String get cartHeader => "Корзина";
  static String get cartEmpty => "Ваша корзина пуста :(";
  static String get categoryHeader => "Каталог";
  static String get goodsHeader => "Список товаров";
  static String get legtMenuHeader => "Мир сыров!";
  static String get unitsWeight => "гр.";
  static String get cartPrice => "Сумма заказа";
  static String get cartResultPrice => "Итого:";
  static String get cartBonus => "Оплачено бонусами";
  static String get cartUseBonus => "Использовать бонусы";
  static String get cartPlaceOrder => "ОФОРМИТЬ ЗАКАЗ";

  static String get units => "шт.";
  static String get pricePostfix => "р.";
}
class ColorConstants{
  ///color
  static const Color black = Color(0xFF424851);
  static const Color darckBlack = Color(0xFF2C2C2C);

  static const Color darkGray = Color(0xFF858688);
  static const Color gray = Color(0xFFDFDFDF);
  static const Color red = Color(0xFFD93740);
  static const Color background = Color(0xFFEFF3FE);
    //  .fromRGBO(161 ,0.633,0.633,1));
  static const Color goodsBack = Color.fromRGBO(242, 240, 240, 1);
  static const Color goodsBorder = gray;
  static const Color goodsBackShadow = Color.fromRGBO(0, 0, 0, 0.1);

  static const Color mainAppColor = Color(0xFFFFFFFF);

}
class IconConstants{
  static Icon get arrow_back => Icon(Icons.arrow_back,color: ColorConstants.black,);
  static Icon get menu => Icon(Icons.menu,color: ColorConstants.black,);

}
class ParametersConstants{


  static double get appBarHeight => 65;
  ///images
  static double get smallImageBorderRadius => 5;
  static double get smallImageWidth => 50;
  static double get smallImageHeight => 50;

  static double get mediumImageBorderRadius => 7;
  static double get mediumImageWidth => 130;
  static double get mediumImageHeight => 130;

  static double get largeImageBorderRadius => 7;
  static double get largeImageWidth => 500;
  static double get largeImageHeight => 150;
  ///
  static double get paddingInFerstListElemetn => 10;
  static EdgeInsets get goodsContainersMargin =>  EdgeInsets.fromLTRB(20,10,20,10);
  //static EdgeInsets get goodsContainersPadding =>  EdgeInsets.fromLTRB(0,,0,0);


  static BoxShadow get shadowDecoration =>BoxShadow(
    blurRadius: 30,
    color: ColorConstants.goodsBackShadow,
    offset: Offset(0.0, 1),
    );
}
class AssetsConstants{


  static  AssetImage get emptyHistory => AssetImage("lib/assets/backgrounds/empty_history.png");
  static  AssetImage get emptyCart => AssetImage("lib/assets/backgrounds/empty_cart.png");

  static  AssetImage get logo => AssetImage("lib/assets/images/logo.png");
  static  AssetImage get splashBackground => AssetImage("lib/assets/backgrounds/splash_screen.png");
}

