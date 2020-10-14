import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Forms/DiscountPreview.dart';

class DiscountList extends StatelessWidget implements PreferredSizeWidget{
  DiscountList({Key key, this.data, this.height}) : super(key: key);
  final double height;
  final Discount data;
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);



    return Container(

      child: FutureBuilder(
        future: Resources().getDiscounts(),
        builder: (context,  projectSnap){

          if(Resources().userProfile.id == null) {
            return Container();
          }

          if (projectSnap.connectionState != ConnectionState.done || projectSnap.data == null){
            return Center(child: CircularProgressIndicator());
          }
          if(projectSnap.hasError){

          } else{
           // sectedCity = Resources().getCityWithId( projectSnap.data.city);
          }

            double padding = (projectSnap.data as List).length ==0?0:10 ;
            return Container(
              height:  height + padding*2,
              width: preferredSize.width,
              padding: EdgeInsets.fromLTRB(padding+10, padding, padding, padding),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: (projectSnap.data as List).length,
                  itemBuilder: (context,index){
                    print(projectSnap.data.toString());
                  return  Padding(
                    padding: const EdgeInsets.only(right:20),
                    child: DiscountPreview(data: projectSnap.data[index],width: 160, height: height,),
                  );

              }),
            );
        },

      ),
    );
  }



}
