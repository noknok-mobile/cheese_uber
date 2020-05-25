
import 'dart:wasm';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Events/Events.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Forms/AutoUpdatingWidget.dart';
import 'package:flutter_cheez/Widgets/Pages/CartPage.dart';

class CustomButton extends StatelessWidget implements PreferredSizeWidget{
  final double width;
  final double height;
  final Function onClick;
  final bool expanded ;
  final Widget child;
  bool enable  = true;
  BoxDecoration decoration;

  CustomButton({Key key, this.width, this.height, this.onClick,this.child,this.decoration,this.expanded = false}) : super(key: key);
  CustomButton.coloredNoBorderLeft({Key key,Color color, this.width, this.height, this.onClick,this.child,this.expanded = false}){
   // this.expanded = expanded;
    decoration = BoxDecoration(

      borderRadius: BorderRadius.horizontal(right:Radius.circular(ParametersConstants.largeImageBorderRadius)) ,
      color: color,
    );
  }
  CustomButton.coloredCustomCircularRadius({Key key, Color color, double topLeft = 0, double topRight = 0, double bottomLeft = 0, double bottomRight = 0, this.width, this.height, this.onClick,this.child,this.expanded = false}){
   // this.expanded = expanded;
    decoration = BoxDecoration(

      borderRadius: BorderRadius.only(
          topLeft:Radius.circular(topLeft),
          topRight:Radius.circular(topRight),
          bottomLeft:Radius.circular(bottomLeft),
          bottomRight:Radius.circular(bottomRight),
      ) ,
      color: color,
    );
  }
  CustomButton.coloredCustomRadius({Key key,Color color,double radius, this.width, this.height, this.onClick,this.child,this.expanded = false}){
  //  this.expanded = expanded;
    decoration = BoxDecoration(

      borderRadius: BorderRadius.only(
        topLeft:Radius.circular(radius),
        topRight:Radius.circular(radius),
        bottomLeft:Radius.circular(radius),
        bottomRight:Radius.circular(radius),
      ) ,
      color: color,
    );
  }
   CustomButton.colored({Key key,Color color,this.enable = true, this.width, this.height, this.onClick,this.child,this.expanded = false}){
    // this.expanded = expanded;
     decoration = BoxDecoration(

       borderRadius: BorderRadius.only(
         topLeft:Radius.circular(ParametersConstants.smallImageBorderRadius),
         topRight:Radius.circular(ParametersConstants.smallImageBorderRadius),
         bottomLeft:Radius.circular(ParametersConstants.smallImageBorderRadius),
         bottomRight:Radius.circular(ParametersConstants.smallImageBorderRadius),
       ) ,
       color: color,
     );
  }

  @override
  Widget build(BuildContext context) {

    BoxDecoration decorationA =enable?decoration:decoration.copyWith(color:Colors.grey);


    return expanded?
      SizedBox(
          width: double.maxFinite, // set width to maxFinite
          child: Container(
          decoration: decorationA,
          child: FlatButton (
            padding: EdgeInsets.all(0),
            onPressed: ()=>enable?onClick():null,
            child: child,
          ),
        ))
      :Container(
        width: width,
        height: height,
        decoration: decorationA,
        child: FlatButton (

          padding: EdgeInsets.all(0),
          onPressed: ()=>enable?onClick():null,
          child: child,
        ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(width,height);



}
class CartButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>_CartButton();
}
class _CartButton extends State<CartButton> {
  int counterCount = 0;
  var subscription;
  @override
  void initState() {

    super.initState();
    /*
    counterCount = Resources().cart.getUniqueGoodsInCart();

    subscription = eventBus.on<UpdateCart>().listen(
            (event){
                var tmpCount = event.cart.getUniqueGoodsInCart();
                if( counterCount != tmpCount){
                  counterCount = tmpCount;
                  setState(()=>{});
                }
              }
            );*/
  }
  @override
  void dispose(){
    super.dispose();
    /*
    subscription.cancel();
    subscription = null;*/
  }
  @override
  Widget build(BuildContext context) {



    return  Stack(
        children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CartButtonRoute( builder: (context) => CartPage()),
                );
              },
              child: Icon(Icons.shopping_cart),
            ),
            Positioned(
              top: 1.0,
              right: 2.0,

              child: new Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                child: Center(
                    child:AutoUpdatingWidget<CartUpdated>(
                      child:(context,data)=> Text(
                       "${Resources().cart.getUniqueGoodsInCart()}",
                      //Resources().cart
                      style: new TextStyle(
                        color: ColorConstants.goodsBack,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500
                      ),
                  ),
                    )
                )
              )
            ),
      ],
    );
  }

}
class CartButtonRoute<T> extends MaterialPageRoute<T> {
  CartButtonRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

    var offsetAnimation;
    {
      var begin = Offset(0.6, 0.7);
      var end = Offset(0, 0);
      var tween = Tween(begin: begin, end: end);
        offsetAnimation = animation.drive(tween);
    }

    var scaleAnimation;
    {
      double begin = 0;
      double end = 1;
      var tween = Tween(begin: begin, end: end);
      scaleAnimation = animation.drive(tween);
    }

    if (settings.isInitialRoute)
      return child;

    return new SlideTransition(position: offsetAnimation, child:  new ScaleTransition(scale: scaleAnimation,child:new FadeTransition(opacity: animation, child: child)) );
  }
}