import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tuple/tuple.dart';
class TextConstants{
  static String get infoHeader => "Инфо";
  static String get orderHeader => "Заказы";
  static String get cartHeader => "Корзина";
  static String get showProfile => "Смотреть профиль";
  static String get cartEmpty => "Ваша корзинакорзина пуста :(";
  static String get categoryHeader => "Каталог";
  static String get cityTitle => "Город: ";
  static String get shopTitle => "Магазин: ";
  static String get goodsHeader => "Список товаров";
  static String get legtMenuHeader => "Мир сыров!";
  static String get unitsWeight => "гр.";
  static String get cartPrice => "Сумма заказа";
  static String get cartResultPrice => "Итого:";
  static String get cartBonus => "Оплачено бонусами";
  static String get cartNoBonuses => "У вас еще нет бонусов";
  static String get cartUseBonus => "Использовать бонусы";
  static String get cartPlaceOrder => "ОФОРМИТЬ ЗАКАЗ";
  static String get cartAddToOrder => "В КОРЗИНУ";
  static String get detailsHeader => "Карточка товара";
  static String get units => "шт.";
  static String get wUnits => "гр.";
  static String get pricePostfix => "р.";
  static String get btnNext => "продолжить";
  static String get selectCity => "Выберите магазин";
  static String get yourCity => "Ваш город";
  static String get btnYes => "ДА";
  static String get btnChange => "ИЗМЕНИТЬ";
  static String get hello => "Добро пожаловать в МИР СЫРОВ";


  static List<Tuple2<String,String>> get informationHeader => [
    Tuple2<String,String>("О магазине","http://cheese.noknok.ru/company/"),
    Tuple2<String,String>("Оплата","http://cheese.noknok.ru/help/delivery/"),
    Tuple2<String,String>("Доставка","http://cheese.noknok.ru/help/payment/"),
    Tuple2<String,String>("Персональные данные","http://cheese.noknok.ru/include/licenses_detail.php"),
    Tuple2<String,String>("Правила обмена и возврата товара","http://cheese.noknok.ru/help/warranty/"),
    Tuple2<String,String>("Правила обмена и возврата товара","http://cheese.noknok.ru/help/warranty/"),
    Tuple2<String,String>("Контакты","http://cheese.noknok.ru/contacts/stores/"),

  ];
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
  static Icon get arrow_front => Icon(Icons.arrow_right,color: ColorConstants.black,);
  static Icon get arrow_back => Icon(Icons.arrow_back,color: ColorConstants.black,);
  static Icon get menu => Icon(Icons.menu,color: ColorConstants.black,);

}
class ParametersConstants{
  //statis String googleServiceApiKey =
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

static Decoration get BoxShadowDecoration => BoxDecoration(
  color: ColorConstants.mainAppColor,
  borderRadius:
  BorderRadius.circular(ParametersConstants.largeImageBorderRadius),
  border: Border.all(color: ColorConstants.goodsBorder.withOpacity(0.1)),
  boxShadow: [
  ParametersConstants.shadowDecoration,
  ],
  );
  static BoxShadow get shadowDecoration =>BoxShadow(
    blurRadius: 30,
    color: ColorConstants.goodsBackShadow,
    offset: Offset(0.0, 1),
    );
}
class AssetsConstants{

  static  Image get iconCheckBox => Image.asset(
    'lib/assets/icons/check_box.png',
  );

  static  SvgPicture get iconCheese => SvgPicture.asset(
    'lib/assets/icons/cheese.svg',
  );
  static  SvgPicture get iconRoundInfoBtn => SvgPicture.asset(
    'lib/assets/icons/round-information-button.svg',
  );
  static  SvgPicture get iconShoppingBag => SvgPicture.asset(
    'lib/assets/icons/shopping-bag.svg',
  );
  static  SvgPicture get iconShoppingBasket => SvgPicture.asset(
    'lib/assets/icons/shopping-basket.svg',
  );
  static  AssetImage get emptyHistory => AssetImage("lib/assets/backgrounds/empty_history.png");

  static  AssetImage get emptyCart => AssetImage("lib/assets/backgrounds/empty_cart.png");

  static  AssetImage get logo => AssetImage("lib/assets/images/logo.png");
  static  AssetImage get splashBackground => AssetImage("lib/assets/backgrounds/splash_screen.png");
  static  AssetImage get drawerBackground => AssetImage("lib/assets/backgrounds/drawer.png");
}

