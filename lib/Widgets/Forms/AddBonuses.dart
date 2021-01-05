import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Utils/SharedValue.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Buttons/CircleThumbShape.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';

import 'AutoUpdatingWidget.dart';

class AddBonuses extends StatefulWidget {
  SharedValue<double> usedBonuses = SharedValue(value: 0);
  @override
  @override
  State<StatefulWidget> createState() => _AddBonusesState();
}

class _AddBonusesState extends State<AddBonuses> {
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    var bonusCount = Resources()
        .userProfile
        .bonusPoints
        .clamp(0, Resources().cart.cartPrice / 2);

    return FlatButton(
        onPressed: () => {},
        child: Container(
          height: 60,
          padding: EdgeInsets.fromLTRB(20, 15, 5, 20),
          decoration: ParametersConstants.BoxShadowDecoration,
          child: bonusCount > 0
              ? _buildBonuses(context, bonusCount)
              : _buildNoBonuses(context),
        ));
  }

  Widget _buildNoBonuses(BuildContext context) {
    return Center(child: CustomText.black16px(TextConstants.cartNoBonuses));
  }

  Widget _buildBonuses(BuildContext context, double bonuses) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => {
        showModalBottomSheet(
            context: context,
            builder: (buildContext) {
              return Container(
                  height: 200,
                  child: BonuceSlider(
                    usedBonuses: widget.usedBonuses,
                    maxBonuses: bonuses,
                  ));
            })
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            children: <Widget>[
              CustomText.black16px(TextConstants.cartUseBonus),
              Expanded(child: Container()),
              AutoUpdatingWidget<CartUpdated>(
                  child: (context, e) => CustomText.black16px(
                      "${Resources().userProfile.bonusPoints - Resources().cart.bonusPoints}"))
            ],
          ),
        ),
      ),
    );
  }
}

class BonuceSlider extends StatefulWidget {
  final SharedValue<double> usedBonuses;
  final double maxBonuses;
  const BonuceSlider({Key key, this.usedBonuses, this.maxBonuses})
      : super(key: key);
  @override
  @override
  State<StatefulWidget> createState() => _BonuceSliderState();
}

class _BonuceSliderState extends State<BonuceSlider> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10),
            width: 9999,
            child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: ColorConstants.red,
                  inactiveTrackColor: ColorConstants.gray,
                  trackHeight: 6,
                  thumbColor: ColorConstants.background,
                  thumbShape: CircleThumbShape(
                      mainColor: ColorConstants.mainAppColor,
                      thumbRadius: 15,
                      innerColor: ColorConstants.red,
                      borderColor: ColorConstants.gray,
                      innerThumbRadius: 5),
                ),
                child: Slider(
                    min: 0,
                    max: widget.maxBonuses,
                    divisions: widget.maxBonuses.toInt(),
                    value: widget.usedBonuses.value,
                    onChanged: (double newValue) => {
                          setState(() => {
                                widget.usedBonuses.value = newValue,
                              })
                        })),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CustomText.black14px(TextConstants.cartBonusCount),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText.red24px(
                            widget.usedBonuses.value.toInt().toString(),
                            align: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Expanded(flex: 1, child: Container(),),
                Expanded(
                  flex: 3,
                  child: CustomButton.colored(
                      width: 125,
                      height: 40,
                      color: ColorConstants.red,
                      child: CustomText.white12px(
                          TextConstants.btnYes.toUpperCase()),
                      onClick: () {
                        Resources().cart.setBonusPoints =
                            widget.usedBonuses.value.toInt();
                        Navigator.of(context).pop();
                      }),
                )

                //Navigator.of(context).push(new MaterialPageRoute(builder:(context){ return  SelectAddres();}));
              ],
            ),
          ),
        ],
      ),
    );
  }
}
