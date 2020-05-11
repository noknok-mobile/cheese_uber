import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'Events/Events.dart';
import 'Resources/Constants.dart';
import 'Widgets/Pages/HomePage.dart';
import 'Widgets/Pages/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {



  @override
  State<StatefulWidget> createState() => _RootPageState();
}
class _RootPageState extends State<MyApp>{
  bool loaded = false;



  static Map<int, Color> colors =
  {
    50:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, .1),
    100:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, .2),
    200:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, .3),
    300:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, .4),
    400:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, .5),
    500:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, .6),
    600:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, .7),
    700:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, .8),
    800:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, .9),
    900:Color.fromRGBO(ColorConstants.mainAppColor.red,ColorConstants.mainAppColor.green,ColorConstants.mainAppColor.blue, 1),
  };


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventBus.on<AllUpToDate>().listen((event) {

      setState(() {
        loaded = true;

      });
    });
    Resources().loadAllData();
  }
  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    MaterialColor colorCustom = MaterialColor( ColorConstants.mainAppColor.value, colors);
    return MaterialApp(
        title: 'Flutter Demo',
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
        brightness:     Brightness.light,
        primarySwatch:  colorCustom,
        textSelectionColor: ColorConstants.red,
        textSelectionHandleColor: ColorConstants.red,
        primaryColor: ColorConstants.background,
        scaffoldBackgroundColor: ColorConstants.background,
        bottomAppBarColor: ColorConstants.mainAppColor,
        accentColor:ColorConstants.red,
        buttonColor:ColorConstants.red,
        textTheme: TextTheme(
        headline:    TextStyle(fontSize: 24,color:ColorConstants.black,fontWeight: FontWeight.w500,),
    subhead:    TextStyle(fontSize: 32,color:ColorConstants.darkGray,fontWeight: FontWeight.w500),
    subtitle:    TextStyle(fontSize: 18,color:ColorConstants.darckBlack,fontWeight: FontWeight.w800),
    title:       TextStyle(fontSize: 20,color:ColorConstants.mainAppColor,fontWeight: FontWeight.w500),
    button: TextStyle(fontSize: 24,color:ColorConstants.mainAppColor,fontWeight: FontWeight.w500),

    //       TextStyle(fontSize: 20,color:ColorConstants.mainAppColor,fontWeight: FontWeight.w500),
    body1:        TextStyle(fontSize: 16,color:ColorConstants.black,fontWeight: FontWeight.w800),
    body2:        TextStyle(fontSize: 12,color:ColorConstants.darkGray,fontWeight: FontWeight.w500),
    )
    ),
    home : Stack(
      children: <Widget>[
        AnimatedOpacity(
            opacity: loaded?0:1,

            duration: const Duration(milliseconds: 800),
            child: SplashScreen())
        ,
        AnimatedOpacity(
            opacity: loaded?1:0,
            duration: const Duration(milliseconds: 1000),
            child:  AbsorbPointer(absorbing: loaded?false:true,child: HomePage()),


        ),

      ],
    )




  );}



}


