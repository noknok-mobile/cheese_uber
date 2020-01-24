import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cheez/Resources/Constants.dart';

import 'Buttons.dart';

class CountButtonGroup extends StatefulWidget implements PreferredSizeWidget{
  final Function getText;
  final Function getCount;
  final Function setCount;

  const CountButtonGroup({Key key, this.getText, this.setCount,this.getCount}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>_CountButtonGroupState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;


}

class _CountButtonGroupState extends State<CountButtonGroup> with TickerProviderStateMixin{
  AnimationController _animationController;
  Animation<double> _opacityAnimation;
  Animation<double> _borderAnimation;
  TextEditingController _controller;
  @override
  void initState() {

    super.initState();
    _controller = TextEditingController();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,));

    _borderAnimation = Tween<double>(
      begin: ParametersConstants.smallImageBorderRadius,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,));

    _animationController.value = widget.getCount() == 0 ? 0 :1;
    if(_animationController.value == 1){
      var text = widget.getText();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    }

    //_updateAnimation();
  }
  void _updateAnimation(){
    var text = widget.getText();
    _controller.value = _controller.value.copyWith(
      text: text,
      selection:
      TextSelection(baseOffset: text.length, extentOffset: text.length),
      composing: TextRange.empty,
    );

      if(widget.getCount() == 0 ){

        _animationController.reverse();
      } else{

        _animationController.forward();
      }
  }


  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget _) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[


            Opacity(

                opacity: _opacityAnimation.value ,
                child: CustomButton.coloredCustomCircularRadius(
                  topLeft: ParametersConstants.smallImageBorderRadius,
                  bottomLeft: ParametersConstants.smallImageBorderRadius,
                  width: 36,
                  height: 36,
                  color: ColorConstants.gray,
                  onClick: () => setState(()=>{widget.setCount(widget.getCount()-1),_updateAnimation()}),
                      child: Text("-",
                          textAlign: TextAlign.center,

                          style: Theme.of(context)
                              .textTheme
                              .button.apply(color: ColorConstants.black)),
                )),
            Opacity(

                opacity:_opacityAnimation.value,
                child: Container(
                    decoration: BoxDecoration(

                        border:Border(top: BorderSide(width: 1,color:ColorConstants.gray),bottom: BorderSide(width: 1,color: ColorConstants.gray))
                    ),
                    height: 36,
                    width: 68.0 * _animationController.value,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child:TextField(
                      maxLines: 1,
                      decoration: null,
                      style: Theme.of(context)
                        .textTheme
                        .body1,
                      textAlign: TextAlign.center,
                      enableInteractiveSelection: false,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      cursorColor: ColorConstants.red,

                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                    controller: _controller,

                    onSubmitted:  (String value)=>{setState(()=>{widget.setCount(int.tryParse(value)),_updateAnimation()})},
                    ))),
            CustomButton.coloredCustomCircularRadius(
              topLeft: _borderAnimation.value,
              bottomLeft: _borderAnimation.value,
              topRight: ParametersConstants.smallImageBorderRadius,
              bottomRight: ParametersConstants.smallImageBorderRadius,
              width: 36,
              height: 36,
              color: ColorConstants.red,
              onClick: () => setState(()=>{widget.setCount(widget.getCount()+1),_updateAnimation()}),
              child: Text("+",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .button),
            )
          ]);
    });
  }

}