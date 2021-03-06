import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Pages/CartPage.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';
import 'package:flutter_cheez/Widgets/Pages/LoginPage.dart';
import 'package:flutter_cheez/Widgets/Pages/OrdersPage.dart';
import 'Events/Events.dart';
import 'Resources/Constants.dart';
import 'Widgets/Pages/HomePage.dart';
import 'Widgets/Pages/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppmetricaSdk()
      .activate(apiKey: '02e66a2a-b34b-435f-aeed-398887cb15c4');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<MyApp> {
  bool loaded = false;

  static Map<int, Color> colors = {
    50: Color.fromRGBO(
        ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green,
        ColorConstants.mainAppColor.blue,
        .1),
    100: Color.fromRGBO(
        ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green,
        ColorConstants.mainAppColor.blue,
        .2),
    200: Color.fromRGBO(
        ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green,
        ColorConstants.mainAppColor.blue,
        .3),
    300: Color.fromRGBO(
        ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green,
        ColorConstants.mainAppColor.blue,
        .4),
    400: Color.fromRGBO(
        ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green,
        ColorConstants.mainAppColor.blue,
        .5),
    500: Color.fromRGBO(
        ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green,
        ColorConstants.mainAppColor.blue,
        .6),
    600: Color.fromRGBO(
        ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green,
        ColorConstants.mainAppColor.blue,
        .7),
    700: Color.fromRGBO(
        ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green,
        ColorConstants.mainAppColor.blue,
        .8),
    800: Color.fromRGBO(
        ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green,
        ColorConstants.mainAppColor.blue,
        .9),
    900: Color.fromRGBO(ColorConstants.mainAppColor.red,
        ColorConstants.mainAppColor.green, ColorConstants.mainAppColor.blue, 1),
  };

  @override
  void initState() {
    // TODO: implement initStat
    super.initState();

    eventBus.on<AllUpToDate>().listen((event) {
      setState(() {
        loaded = true;
        print("AllUpToDate");
      });
    });

    Resources().startLoad();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    MaterialColor colorCustom =
        MaterialColor(ColorConstants.mainAppColor.value, colors);
    return MaterialApp(
        title: 'Flutter Demo',
        routes: {
          '/cart': (context) => CartPage(),
          '/category': (context) => CategoryPage(),
          '/login': (context) => LoginPage(),
          '/orders': (context) => OrdersPage()
        },
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.displayColor

            fontFamily: 'Roboto',
            brightness: Brightness.light,
            primarySwatch: colorCustom,
            textSelectionColor: ColorConstants.red,
            textSelectionHandleColor: ColorConstants.red,
            primaryColor: ColorConstants.background,
            scaffoldBackgroundColor: ColorConstants.background,
            bottomAppBarColor: ColorConstants.mainAppColor,
            accentColor: ColorConstants.red,
            buttonColor: ColorConstants.red,
            textTheme: TextTheme(
              headline5: TextStyle(
                fontSize: 24,
                color: ColorConstants.black,
                fontWeight: FontWeight.w500,
              ),
              subtitle1: TextStyle(
                  fontSize: 32,
                  color: ColorConstants.darkGray,
                  fontWeight: FontWeight.w500),
              subtitle2: TextStyle(
                  fontSize: 18,
                  color: ColorConstants.darckBlack,
                  fontWeight: FontWeight.w800),
              headline6: TextStyle(
                  fontSize: 20,
                  color: ColorConstants.mainAppColor,
                  fontWeight: FontWeight.w500),
              button: TextStyle(
                  fontSize: 24,
                  color: ColorConstants.mainAppColor,
                  fontWeight: FontWeight.w500),

              //       TextStyle(fontSize: 20,color:ColorConstants.mainAppColor,fontWeight: FontWeight.w500),
              bodyText2: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.black,
                  fontWeight: FontWeight.w800),
              bodyText1: TextStyle(
                  fontSize: 12,
                  color: ColorConstants.darkGray,
                  fontWeight: FontWeight.w500),
            )),
        home: Scaffold(
          key: MyApp.scaffoldKey,
          body: Stack(
            children: <Widget>[
              AnimatedOpacity(
                  opacity: loaded ? 0 : 1,
                  duration: const Duration(milliseconds: 800),
                  child: SplashScreen()),
              AnimatedOpacity(
                opacity: loaded ? 1 : 0,
                duration: const Duration(milliseconds: 1000),
                child: AbsorbPointer(
                    absorbing: loaded ? false : true, child: HomePage()),
              ),
            ],
          ),
        ));
  }
}
