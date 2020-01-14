
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Forms/Goods.dart';
import 'package:flutter_cheez/Widgets/Forms/GoodsTabBar.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoodsPage extends StatelessWidget {
  GoodsPage({Key key, this.categoryId,this.data}): super(key: key);

  final int categoryId;
  final List<CategoryData> data;
  final String title = TextConstants.goodsHeader;
  @override
  Widget build(BuildContext context) {
    List<Tab> tabsTitles = List<Tab>();
    List<Widget> tabsContent = List<Widget>();
    print("build GoodsPage $categoryId");
    data.forEach(
            (f)=>{
                tabsTitles.add(Tab(child:Text( f.title))),

                tabsContent.add(
                Center(

                  child: FutureBuilder(
                      future: Resources().getGoodsInCategory(f.id),
                      builder: (context,AsyncSnapshot<List<GoodsData>> projectSnap) {
                        if (projectSnap.hasError) {
                          print('project snapshot data is: ${projectSnap.data}');
                          return Container();
                        }
                        if (projectSnap.connectionState != ConnectionState.done) {
                          return CircularProgressIndicator();
                        }
                        return ListView.builder(

                          shrinkWrap: true,
                          // physics: BouncingScrollPhysics(),
                          itemCount: projectSnap.data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[

                                SizedBox(
                                height: index == 0 ? ParametersConstants.paddingInFerstListElemetn:0

                                ),
                                Goods(data: projectSnap.data[index]),
                                SizedBox(
                                    height: projectSnap.data.length-1 == index  ? 80:0 ),
                              ],
                            );
                          },
                        );
                      }
                  ),
            //child: Text('Hello World!'),
            ),),


    });

    return DefaultTabController(
        length: data.length,
        initialIndex:data.indexOf(data.firstWhere((t)=>t.id == categoryId)),
        child:  Scaffold(
            appBar: NextPageAppBar(
              height: ParametersConstants.appBarHeight,
              title: title,
              bottom:  TabBar(
                labelColor: ColorConstants.darkGray,
                unselectedLabelColor: ColorConstants.gray,
                indicatorColor:ColorConstants.red ,
                indicatorWeight: 3,
                labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                isScrollable: true,
                tabs:tabsTitles,

              ),
            ),

            floatingActionButton: CartButton(),

            body:TabBarView(
                children: tabsContent,)

            ));
  }
  /*
  @override
  _GoodsPageState createState() => _GoodsPageState();*/
}
/*
class _GoodsPageState extends State<GoodsPage> {


}*/