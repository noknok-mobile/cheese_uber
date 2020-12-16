import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';

class DoneInputView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorConstants.background,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: CupertinoButton(
            padding: EdgeInsets.only(right: 24, top: 8, bottom: 8),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text(
              "Готово",
              style: TextStyle(
                  color: ColorConstants.red, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
