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
import 'package:shared_preferences/shared_preferences.dart';
import 'ChangeCity.dart';

class LoginPage extends StatefulWidget {
  String errorMessage="";
  String loginErrorMessage="";
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


  SharedValue<String> phone =   SharedValue<String>(value:"+7(");
  SharedValue<String> pass =   SharedValue<String>(value:'');
  SharedValue<String> name =   SharedValue<String>(value:"");
  SharedValue<String> email =   SharedValue<String>(value:'');

  final _registerFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _scafoldKey = GlobalKey<FormState>();


  @override
  void initState()  {
    super.initState();
  /*  final SharedPreferences prefs = await _prefs;
    email.value = prefs.getString("email");
    pass.value = prefs.getString("pass");*/
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 10,),
                CustomText.black14px(TextConstants.loginOrRegister,align: TextAlign.left,),
                SizedBox(height: 18,),
                widget.loginErrorMessage.isEmpty?Container():Center(child: Container(padding: EdgeInsets.only(top:10,bottom: 10), child:CustomText.red14px(widget.loginErrorMessage,align: TextAlign.left,))),
                InputFieldEmail(value: email,),
                SizedBox(height: 16,),
                InputFieldPassword(value: pass,),
                SizedBox(height: 16,),
                CustomButton.colored(enable:!widget.inProgress, height:45,width: 9999, color: ColorConstants.red,child: CustomText.white12px("Войти"), onClick: (){
                  widget.loginErrorMessage = "";
                  widget.errorMessage = "";
                  widget.inProgress = true;

                  if (_formKey.currentState.validate()) {
                    print(email.value+" "+pass.value);
                    _formKey.currentState.save();
                    Resources().loginWithData(email.value, pass.value).then((value) async{
                      final SharedPreferences prefs = await _prefs;
                      prefs.setString("email",  email.value);
                      prefs.setString("pass",   pass.value);


                      if(value == "OK"){
                        print(value);
                        Navigator.push(
                            context,
                            MaterialPageRoute( builder: (context) => ChangeCity()));
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
                  setState(() {

                  });
                }
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
                SizedBox(height: 10,),
                CustomText.black14px(TextConstants.loginOrRegister,align: TextAlign.center,),
                SizedBox(height: 18,),
                widget.errorMessage.isEmpty?Container():Center(child: Container(padding: EdgeInsets.only(top:10,bottom: 10), child:CustomText.red14px(widget.errorMessage,align: TextAlign.left,))),
                InputFieldName(label: "Имя",value:name),
                SizedBox(height: 18,),
                InputFieldEmail(value: email,),
                SizedBox(height: 18,),
                InputFieldPhone(value: phone,),
                SizedBox(height: 16,),
                InputFieldPassword(value:pass),
                SizedBox(height: 16,),
                CustomButton.colored(enable: !widget.inProgress, height:45,width: 9999, color: ColorConstants.red,child: CustomText.white12px("Зарегистрироваться"),onClick: (){
                  widget.inProgress = true;
                  if (_registerFormKey.currentState.validate()) {
                    _registerFormKey.currentState.save();


                    Resources().registerWithData(email.value, pass.value,name.value,phone.value).then((value) async{

                      widget.loginErrorMessage = "";
                      widget.errorMessage = "";
                      final SharedPreferences prefs = await _prefs;
                      prefs.setString("email",  email.value);
                      prefs.setString("pass",   pass.value);

                      if(value == "OK"){
                        print(value);
                        Navigator.push(
                            context,
                            MaterialPageRoute( builder: (context) => ChangeCity()));
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
                    print("phone "+phone.value);
                  }
                  setState(() {

                  });
                },)
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
            key:_scafoldKey,
              appBar: NextPageAppBar(
                height: ParametersConstants.appBarHeight * 0.3,
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
