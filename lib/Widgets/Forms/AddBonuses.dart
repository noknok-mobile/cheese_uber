import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';

class AddBonuses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    var bonusCount = Resources().userProfile.bonusPoints;
    return FlatButton(
        onPressed: () => {},
        child: Container(
          height: 60,
          padding: EdgeInsets.fromLTRB(20, 15, 3, 20),
          decoration: ParametersConstants.BoxShadowDecoration,
          child: bonusCount > 0 ? _buildBonuses(context):_buildNoBonuses(context),
        ));
  }
  Widget _buildNoBonuses(BuildContext context)
  {
    return Center(child: CustomText.black16px(TextConstants.cartNoBonuses));
  }
  Widget _buildBonuses(BuildContext context)
  {
    return Center(child: CustomText.black16px(TextConstants.cartNoBonuses));
  }
}
