import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldName.dart';
import 'package:flutter_cheez/Widgets/Forms/InputFieldPhone.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';
import 'package:flutter_cheez/Widgets/Pages/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OrdersPage.dart';

class UserInfo extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  State<StatefulWidget> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  SharedValue<String> phone =
      SharedValue<String>(value: Resources().userProfile?.phone);
  SharedValue<String> email =
      SharedValue<String>(value: Resources().userProfile?.email);
  SharedValue<String> pass = SharedValue<String>(value: "");
  SharedValue<String> name =
      SharedValue<String>(value: Resources().userProfile?.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: ColorConstants.background,
      appBar: NextPageAppBar(
        height: ParametersConstants.appBarHeight,
        title: TextConstants.profileHeader,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 9999,
          // height: 9999,
          decoration: ParametersConstants.BoxShadowDecoration,
          margin: const EdgeInsets.all(20),

          child: Form(
            key: widget._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 16, 16, 16),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText.black20pxBold(
                              Resources().userProfile.username),
                          CustomText.black16px(Resources().userProfile.email),
                        ],
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () async {
                          Future<SharedPreferences> _prefs =
                              SharedPreferences.getInstance();
                          final SharedPreferences prefs = await _prefs;
                          prefs.setString("pass", "");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: CustomText.red14pxUnderline(TextConstants.exit),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: ColorConstants.gray,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrdersPage()));
                      },
                      child: CustomText.black16px(TextConstants.orderHeader)),
                ),
                Container(
                  height: 1,
                  color: ColorConstants.gray,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      CustomText.black16px(TextConstants.bonusPoint),
                      Expanded(
                        child: Container(),
                      ),
                      CustomText.black16px(
                          Resources().userProfile.bonusPoints.toString() +
                              TextConstants.pricePostfix),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: ColorConstants.gray,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 16, 16, 16),
                  child: CustomText.black20pxBold(TextConstants.contactDate),
                ),
                Container(
                  height: 1,
                  color: ColorConstants.gray,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: InputFieldName(
                      label: TextConstants.contactName,
                      value: name,
                      decorated: false),
                ),
                Container(
                  height: 1,
                  color: ColorConstants.gray,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: InputFieldPhone(
                      label: TextConstants.phone,
                      value: phone,
                      decorated: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
