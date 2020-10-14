import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';
import 'package:flutter_cheez/Widgets/Pages/ChangeCity.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Resources().login(),
        builder: (context, AsyncSnapshot<String> projectSnap) {
          if (!projectSnap.hasData) {
            print('project snapshot data is: ${projectSnap.data}');
            return Center(child: CircularProgressIndicator());
          }
          if (projectSnap.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          // return CategoryPage();
          if (Resources().userProfile.id != null &&
              Resources().userProfile.selectedShop != 0) {
            print("category page");
            return CategoryPage();
          } else {
            print("ChangeCity page");
            return ChangeCity();
          }

          // if(projectSnap.data !="OK"){

          //   return  LoginPage();//
          // } else{
          //   if(Resources().userProfile.selectedShop!=0)
          //     return CategoryPage();
          //   else
          //     return ChangeCity();
          // }
          return AutoUpdatingWidget<AllUpToDate>(
            child: (context, data) {
              return Container();
            },
          );
        });
  }
}
