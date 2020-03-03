import 'package:flutter/cupertino.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Pages/CategoryPage.dart';
import 'package:flutter_cheez/Widgets/Pages/ChangeCity.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    if(Resources().userProfile.selectedShop.isEmpty){
      return ChangeCity();
    } else{
      return CategoryPage();
    }
  }
}