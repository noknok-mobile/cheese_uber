
import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Drawers/LeftMenu.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/HomePageAppBar.dart';
import 'GoodsPage.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  final String title = TextConstants.categoryHeader;

  @override
  _CategoryPageState createState() => _CategoryPageState();

}

class _CategoryPageState extends State<CategoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: HomePageAppBar(height:ParametersConstants.appBarHeight,title:widget.title,),
        drawer: Drawer(child: LeftMenu()),
        floatingActionButton: CartButton(),

        body: Center(
            child: FutureBuilder(
                future: Resources().getCategory(),
                builder: (context,AsyncSnapshot<List<CategoryData>> projectSnap) {
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
                                height: index == 0 ? ParametersConstants
                                    .paddingInFerstListElemetn : 0,
                                //child: Text('Hello World!'),
                              ),
                              Container(
                                  margin: ParametersConstants.goodsContainersMargin,
                                  child:
                                  CachedImage.imageForCategory(url: projectSnap
                                      .data[index].imageUrl,
                                      child: FlatButton(
                                        padding:  EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                GoodsPage(
                                                    categoryId: projectSnap.data[index]
                                                        .id, data: projectSnap.data)),
                                          );
                                        },
                                        child: Container(

                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(ParametersConstants.largeImageBorderRadius),
                                              gradient: LinearGradient(
                                                  begin: FractionalOffset.topCenter,
                                                  end: FractionalOffset.bottomCenter,
                                                  colors: [
                                                    Colors.grey.withOpacity(0.0),
                                                    Colors.black.withOpacity(0.5),
                                                  ],
                                                  stops: [
                                                    0.0,
                                                    1.0
                                                  ])
                                          ),
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                            child: Text(
                                              projectSnap.data[index].title,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .title,
                                            ),
                                          ),
                                        ),
                                      )
                                  )),
                            ]
                        );
                      });
                })
        )
    );
  }
}