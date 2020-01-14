import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Forms/CartGoods.dart';
import 'package:flutter_cheez/Widgets/Forms/Goods.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  final String title = TextConstants.cartHeader;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ColorConstants.background,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 100.0,color:ColorConstants.mainAppColor),
        ),
        //floatingActionButton: CartButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body:Center(child: FutureBuilder(

          future: Resources().getCart(),
          builder: (context,AsyncSnapshot<Map<int,int>> projectSnap) {
            if(projectSnap.hasError){
              print('project snapshot data is: ${projectSnap.data}');
              return Container();
            }
            if ( projectSnap.connectionState != ConnectionState.done){
              return CircularProgressIndicator();
            }
            return ListView.builder(

              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                        height: index == 0 ? ParametersConstants.paddingInFerstListElemetn:0 ),
                    CartGoods( data: Resources().getGodById( projectSnap.data.keys.toList()[index]))
                  ],
                );
              },
            );},
        ),

        ));
  }
}