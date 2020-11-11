import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';
import 'package:flutter_cheez/Widgets/Pages/ChangeCity.dart';
import 'package:flutter_cheez/Widgets/Pages/LoginPage.dart';
import 'package:flutter_cheez/Widgets/Pages/SelectShop.dart';
import 'package:flutter_cheez/Widgets/Pages/StartPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Resources().login(),
        builder: (context, AsyncSnapshot<String> projectSnap) {
          // if (!projectSnap.hasData) {
          //   print('project snapshot data is: ${projectSnap.data}');
          //   return Center(child: CircularProgressIndicator());
          // }
          if (projectSnap.hasError) {
            print("ERROR -- " + projectSnap.error.toString());
          }

          if (projectSnap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return SelectShop();
        });
  }
}
