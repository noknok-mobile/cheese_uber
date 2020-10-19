import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldEmail.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldName.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldPassword.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldPhone.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldText.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';
import 'package:flutter_cheez/Widgets/Pages/CartPage.dart';
import 'package:flutter_cheez/Widgets/Pages/WebPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChangeCity.dart';

class LoginPageArguments {
  final String backRoute;

  LoginPageArguments(this.backRoute);
}

class LoginPage extends StatefulWidget {
  String errorMessage = "";
  String loginErrorMessage = "";
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    List<Tab> tabsTitles = List<Tab>();
    List<Widget> tabsContent = List<Widget>();
  }

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedValue<String> phone = SharedValue<String>(value: "+7(");
  SharedValue<String> pass = SharedValue<String>(value: '');
  SharedValue<String> name = SharedValue<String>(value: "");
  SharedValue<String> email = SharedValue<String>(value: '');

  final _registerFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    /*  final SharedPreferences prefs = await _prefs;
    email.value = prefs.getString("email");
    pass.value = prefs.getString("pass");*/
  }

  @override
  Widget build(BuildContext context) {
    final LoginPageArguments args = ModalRoute.of(context).settings.arguments;

    List<Tab> tabsTitles = List<Tab>();
    List<Widget> tabsContent = List<Widget>();
    tabsTitles.add(Tab(
      child: Container(
          padding: const EdgeInsets.only(top: 25),
          alignment: Alignment.center,
          child: CustomText.black12px(TextConstants.login)),
    ));
    tabsTitles.add(Tab(
      child: Container(
          padding: const EdgeInsets.only(top: 25),
          alignment: Alignment.center,
          child: CustomText.black12px(TextConstants.register)),
    ));
    tabsContent.add(Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomText.black18pxBold(TextConstants.hello),
                SizedBox(
                  height: 10,
                ),
                CustomText.black14px(
                  TextConstants.loginOrRegister,
                  align: TextAlign.center,
                ),
                SizedBox(
                  height: 18,
                ),
                widget.loginErrorMessage.isEmpty
                    ? Container()
                    : Center(
                        child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: CustomText.red14px(
                              widget.loginErrorMessage,
                              align: TextAlign.left,
                            ))),
                InputFieldEmail(value: email, decorated: false),
                SizedBox(
                  height: 16,
                ),
                InputFieldPassword(value: pass, decorated: false),
                SizedBox(
                  height: 16,
                ),
                CustomButton.colored(
                    enable: !widget.inProgress,
                    height: 45,
                    width: 9999,
                    color: ColorConstants.red,
                    child: CustomText.white12px("Войти".toUpperCase()),
                    onClick: () {
                      widget.loginErrorMessage = "";
                      widget.errorMessage = "";
                      widget.inProgress = true;

                      if (_formKey.currentState.validate()) {
                        print(email.value + " " + pass.value);
                        _formKey.currentState.save();
                        Resources()
                            .loginWithData(email.value, pass.value)
                            .then((value) async {
                          final SharedPreferences prefs = await _prefs;
                          prefs.setString("email", email.value);
                          prefs.setString("pass", pass.value);

                          if (value == "OK") {
                            print(value);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => CartPage()));

                            Navigator.pushNamed(context, args.backRoute);
                          } else {
                            print(value);

                            setState(() {
                              widget.inProgress = false;
                              widget.loginErrorMessage = value;
                            });
                          }
                        });
                      } else {
                        widget.inProgress = false;
                      }
                      setState(() {});
                    }),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () => {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final _formKey = GlobalKey<FormState>();
                        SharedValue<String> email =
                            SharedValue<String>(value: '');
                        return SimpleDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ParametersConstants.largeImageBorderRadius),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          // shape:  ShapeBorder().,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ParametersConstants
                                          .largeImageBorderRadius))),
                              height: 100,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    InputFieldEmail(
                                      value: email,
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    CustomButton.colored(
                                      color: ColorConstants.red,
                                      enable: !widget.inProgress,
                                      height: 45,
                                      width: 9999,
                                      child: CustomText.white12px(
                                          "Отправить".toUpperCase()),
                                      onClick: () => {
                                        Resources().checkMail(email.value),
                                        if (_formKey.currentState.validate())
                                          Navigator.of(context).pop()
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  },
                  child: CustomText.red14pxUnderline(TextConstants.forgotPass),
                )
              ],
            ),
          ),
        ),
      ),
    ));
    tabsContent.add(Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            autovalidate: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomText.black18pxBold(TextConstants.hello),
                SizedBox(
                  height: 10,
                ),
                CustomText.black14px(
                  TextConstants.loginOrRegister,
                  align: TextAlign.center,
                ),
                SizedBox(
                  height: 18,
                ),
                widget.errorMessage.isEmpty
                    ? Container()
                    : Center(
                        child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: CustomText.red14px(
                              widget.errorMessage,
                              align: TextAlign.left,
                            ))),
                InputFieldName(
                  label: "Имя",
                  value: name,
                  decorated: false,
                ),
                SizedBox(
                  height: 18,
                ),
                InputFieldEmail(value: email, decorated: false),
                SizedBox(
                  height: 18,
                ),
                InputFieldPhone(value: phone, decorated: false),
                SizedBox(
                  height: 16,
                ),
                InputFieldPassword(value: pass, decorated: false),
                SizedBox(
                  height: 16,
                ),
                CustomButton.colored(
                  enable: !widget.inProgress,
                  height: 45,
                  width: 9999,
                  color: ColorConstants.red,
                  child:
                      CustomText.white12px("Зарегистрироваться".toUpperCase()),
                  onClick: () {
                    widget.inProgress = true;
                    if (_registerFormKey.currentState.validate()) {
                      _registerFormKey.currentState.save();

                      Resources()
                          .registerWithData(
                              email.value, pass.value, name.value, phone.value)
                          .then((value) async {
                        widget.loginErrorMessage = "";
                        widget.errorMessage = "";
                        final SharedPreferences prefs = await _prefs;
                        prefs.setString("email", email.value);
                        prefs.setString("pass", pass.value);

                        if (value == "OK") {
                          print(value);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ChangeCity()));
                          Navigator.pushNamed(context, args.backRoute);
                        } else {
                          //widget.inProgress = false;
                          widget.inProgress = false;
                          setState(() {
                            widget.errorMessage = value;
                          });
                        }
                      });
                    } else {
                      widget.inProgress = false;
                      print("phone " + phone.value);
                    }
                    setState(() {});
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebPage(
                            url: TextConstants.politicsUrl,
                            title: TextConstants.politicsHeader,
                          ),
                        )),
                    child: CustomText.black12pxUnderline(
                      TextConstants.politics,
                      align: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
    // TODO: implement build
    return SafeArea(
      child: DefaultTabController(
          length: tabsContent.length,
          initialIndex: 0,
          child: Scaffold(
              key: _scafoldKey,
              appBar: NextPageAppBar(
                height: ParametersConstants.appBarHeight,
                title: "Авторизация",
                bottom: TabBar(
                  labelColor: ColorConstants.darkGray,
                  unselectedLabelColor: ColorConstants.gray,
                  indicatorColor: ColorConstants.red,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  tabs: tabsTitles,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(0),
                child: Center(
                  child: TabBarView(
                    children: tabsContent,
                  ),
                ),
              ))),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeCity(),
              ),
            );
          },
          child: Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
