import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tuple/tuple.dart';

class TextConstants {
  static String get login => "Вход";
  static String get exit => "Выход";
  static String get register => "Регистрация";
  static String get infoHeader => "Инфо";
  static String get newOrderHeader => "Оформление заказа";
  static String get orderHeader => "Заказы";
  static String get cartHeader => "Корзина";
  static String get showProfile => "Смотреть профиль";
  static String get profileHeader => "Профиль";
  static String get ordersEmpty => "Вы еще не сделали ни одного заказа :(";
  static String get cartEmpty => "Ваша корзина пуста :(";
  static String get categoryHeader => "Каталог";
  static String get cityTitle => "Город: ";
  static String get shopTitle => "Магазин: ";
  static String get goodsHeader => "Список товаров";
  static String get legtMenuHeader => "Мир сыров!";
  static String get unitsWeight => "гр.";
  static String get cartPrice => "Сумма заказа";
  static String get cartResultPrice => "Итого:";
  static String get bonusPoint => "Бонусный счет";
  static String get cartBonus => "Оплачено бонусами";
  static String get orderPayHeader => "Оплата";
  static String get orderDeliveryAddress => "Параметры доставки";
  static String get orderDeliveryHeader => "Способ доставки";
  static String get orderDeliveryCurier => "Курьерская доставка";
  static String get orderDeliverySelf => "Самовывоз";
  static String get orderPayCard => "Картой онлайн";

  static String get cartBonusCount => "Количество бонусов для списания";
  static String get cartNoBonuses => "У вас еще нет бонусов";
  static String get cartUseBonus => "Использовать бонусы";
  static String get cartDiplicateOrder => "ПОВТОРИТЬ ЗАКАЗ";
  static String get cartPlaceOrder => "ОФОРМИТЬ ЗАКАЗ";
  static String get cartAddToOrder => "В КОРЗИНУ";
  static String get detailsHeader => "Карточка товара";
  static String get units => "шт";
  static String get wUnits => "гр";
  static String get pricePostfix => "р.";
  static String get btnNext => "продолжить";
  static String get selectCity => "Выберите магазин";
  static String get selectAddressDelivery => "Выберите адрес доставки";
  static String get yourCity => "Ваш город";
  static String get btnYes => "ДА";
  static String get btnChange => "ИЗМЕНИТЬ";
  static String get hello => "Добро пожаловать в МИР СЫРОВ";
  static String get loginOrRegister =>
      "Войдите или зарегистрируйтесь,\n чтобы сделать заказ";

  static String get activeOrders => "Активные";
  static String get finishedOrders => "Выполненные";
  static String get orderNumber => "Заказ №";
  static String get orderCall => "обрабатывается";
  static String get orderDone => "выполнен";
  static String get orderDelivery => "доставляется";
  static String get orderPay => "ожидается оплата";
  static String get orderMakePay => "Оплатить";
  static String get orderSberbankPay => "Страница оплаты";
  static String get pay => "ожидается оплата";
  static String get payMethodCash => "Наличными";
  static String get payMethodOnline => "Онлайн";
  static String get adres => "Адрес";
  static String get delivery => "Доставка";
  static String get deliveryTime => "Время заказа";
  static String get deliveryMethodPickup => "Самовывоз";
  static String get deliveryMethodCourier => "Курьер";
  static String get contactName => "Контактное лицо";
  static String get addresEntrance => "Подъезд";
  static String get addresFloor => "Этаж";
  static String get addresFlat => "Квартира";

  static String get contactDate => "Контактные данные";
  static String get payMethod => "Оплата";
  static String get youAdresHeader => "Ваши адреса для доставки";
  static String get pushNotes => "Получать Push уведомления";
  static String get fio => "ФИО";
  static String get phone => "Телефон";
  static String get email => "E-Mail";
  static String get changePassword => "Сменить пароль";
  static String get password => "Пароль";
  static String get onMap => "На карте";
  static String get defaultAddres => "Адрес по умолчанию";
  static String get newAddres => "Новый адрес доставки";
  static String get addresName => "Название";
  static String get textCopy => "Текст скопирован";
  static String get usePromocode => "Применить промокод";

  static String get forgotPass => "Забыли пороль";

  static String get politicsHeader => "Соглашение";
  static String get politics =>
      "Регистрируясь, вы соглашаетесь с Регламентом работы сайта, Согласием на обработку персональных данных и условиями Договора купли-продажи.";
  static String get politicsUrl =>
      "https://xn--90aij3acc4e.xn--p1ai/include/licenses_detail.php";
  static List<Tuple2<String, String>> get informationHeader => [
        Tuple2<String, String>(
            "О магазине", "https://xn--90aij3acc4e.xn--p1ai/company/"),
        Tuple2<String, String>(
            "Оплата и доставка", "https://xn--90aij3acc4e.xn--p1ai/payment/"),
        Tuple2<String, String>("Персональные данные",
            "https://xn--90aij3acc4e.xn--p1ai/include/licenses_detail.php"),
        // Tuple2<String,String>("Правила обмена и возврата товара","https://xn--90aij3acc4e.xn--p1ai/help/warranty/"),
        Tuple2<String, String>(
            "Контакты", "https://xn--90aij3acc4e.xn--p1ai/contacts/stores/"),
      ];
}

class ColorConstants {
  ///color
  static const Color black = Color(0xFF424851);
  static const Color blackTransparent = Color(0xDD424851);
  static const Color darckBlack = Color(0xFF2C2C2C);

  static const Color darkGray = Color(0xFF858688);

  static const Color red = Color(0xFFD93740);
  static const Color darkRed = Color(0xFF902719);
  static const Color background = Color(0xFFEFF3FE);
  static const Color gray = background; //Color(0xFFDFDFDF);
  //  .fromRGBO(161 ,0.633,0.633,1));
  static const Color goodsBack = Color.fromRGBO(242, 240, 240, 1);
  static const Color goodsBorder = background;
  static const Color goodsBackShadow = Color.fromRGBO(0, 0, 0, 0.1);

  static const Color mainAppColor = Color(0xFFFFFFFF);

  static const Color orderPay = Color(0xFFED3A4F);
  static const Color orderDone = Color(0xFF424851);
  static const Color orderDelivery = Color(0xFF37BC35);
  static const Color orderCall = Color(0xFFEDAB00);
}

class IconConstants {
  static Widget get arrowFront => SvgPicture.asset(
        'lib/assets/icons/arrow_right.svg',
        color: ColorConstants.darkGray,
      );
  static Widget get arrowBack => Transform.rotate(
      angle: 0 * 3.14 / 180,
      child: SvgPicture.asset(
        'lib/assets/icons/arrow_left.svg',
        color: ColorConstants.black,
      ));
  static Widget get arrowDown => Transform.rotate(
      angle: -90 * 3.14 / 180,
      child: SvgPicture.asset(
        'lib/assets/icons/arrow_left.svg',
        color: ColorConstants.mainAppColor,
      ));
  static Widget get arrowDownBlack => Transform.rotate(
      angle: -90 * 3.14 / 180,
      child: SvgPicture.asset(
        'lib/assets/icons/arrow_left.svg',
        color: ColorConstants.black,
      ));
  static Widget get showPass => Transform.rotate(
      angle: 0 * 3.14 / 180,
      child: Container(
        padding: EdgeInsets.all(10),
        child: SvgPicture.asset('lib/assets/icons/show_pass.svg',
            color: ColorConstants.darkGray),
      ));
  static Widget get menu => Icon(
        Icons.menu,
        color: ColorConstants.black,
      );
}

class ParametersConstants {
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
  static EdgeInsets get goodsContainersMargin =>
      EdgeInsets.fromLTRB(20, 10, 20, 10);
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
  static BoxShadow get shadowDecoration => BoxShadow(
        blurRadius: 30,
        color: ColorConstants.goodsBackShadow,
        offset: Offset(0.0, 1),
      );
}

class AssetsConstants {
  static Image get iconCheckBox => Image.asset(
        'lib/assets/icons/check_box.png',
      );
  static SvgPicture get discountBG => SvgPicture.asset(
        'lib/assets/backgrounds/discount.svg',
      );
  static SvgPicture get iconCheese => SvgPicture.asset(
        'lib/assets/icons/cheese.svg',
      );
  static SvgPicture get iconRoundInfoBtn => SvgPicture.asset(
        'lib/assets/icons/round-information-button.svg',
      );
  static SvgPicture get iconShoppingBag => SvgPicture.asset(
        'lib/assets/icons/shopping-bag.svg',
      );
  static SvgPicture get iconShoppingBasket => SvgPicture.asset(
        'lib/assets/icons/shopping-basket.svg',
      );
  static SvgPicture get iconOrderCall => SvgPicture.asset(
        'lib/assets/icons/order_call.svg',
      );
  static SvgPicture get iconOrderDelivery => SvgPicture.asset(
        'lib/assets/icons/order_delivery.svg',
      );
  static SvgPicture get iconOrderDone => SvgPicture.asset(
        'lib/assets/icons/order_done.svg',
      );
  static SvgPicture get iconOrderPay => SvgPicture.asset(
        'lib/assets/icons/order_pay.svg',
      );
  static SvgPicture get iconInfoPay => SvgPicture.asset(
        'lib/assets/icons/info_pay.svg',
      );
  static SvgPicture get iconInfoUser => SvgPicture.asset(
        'lib/assets/icons/info_user.svg',
      );
  static SvgPicture get iconInfoTime => SvgPicture.asset(
        'lib/assets/icons/info_time.svg',
      );
  static SvgPicture get iconInfoAdres => SvgPicture.asset(
        'lib/assets/icons/info_adres.svg',
      );
  static SvgPicture get iconInfoDelivery => SvgPicture.asset(
        'lib/assets/icons/info_delivery.svg',
      );
  static SvgPicture get toggleOff => SvgPicture.asset(
        'lib/assets/icons/toggle_off.svg',
      );
  static SvgPicture get toggleOn => SvgPicture.asset(
        'lib/assets/icons/toggle_on.svg',
      );
  static AssetImage get emptyHistory =>
      AssetImage("lib/assets/backgrounds/empty_history.png");

  static AssetImage get emptyCart =>
      AssetImage("lib/assets/backgrounds/empty_cart.png");

  static AssetImage get animatedLogo =>
      AssetImage("lib/assets/images/animated_logo.gif");
  static AssetImage get logo => AssetImage("lib/assets/images/logo.png");
  static AssetImage get splashBackground =>
      AssetImage("lib/assets/backgrounds/splash_screen.png");
  static AssetImage get drawerBackground =>
      AssetImage("lib/assets/backgrounds/drawer.png");
}
