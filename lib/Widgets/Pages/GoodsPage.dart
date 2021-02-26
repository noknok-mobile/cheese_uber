import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Buttons/Buttons.dart';
import 'package:flutter_cheez/Widgets/Drawers/LeftMenu.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/Goods.dart';
import 'package:flutter_cheez/Widgets/Forms/NextPageAppBar.dart';

class GoodsPage extends StatelessWidget {
  GoodsPage({Key key, this.categoryId, this.data}) : super(key: key);

  final int categoryId;

  final List<CategoryData> data;
  final String title = TextConstants.goodsHeader;

  int initialTab = 0;

  Future<List<GoodsData>> loadData(int id) {
    if (data.first.parentId != 0) {
      Resources().allGoods.clear();
    }

    return Resources().loadProductsByCategory(id);
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabsTitles = List<Tab>();
    List<Widget> tabsContent = List<Widget>();

    var newTitle = Resources().getCategoryById(data.first.parentId);

    data.forEach((f) => {
          print(f.id),
          if (Resources().getCategoryWithParent(f.id).length == 0)
            {
              if (f.id == categoryId) initialTab = tabsTitles.length,
              tabsTitles.add(Tab(
                  child: Container(
                      padding: const EdgeInsets.only(top: 25),
                      child: CustomText.black12px(f.title)))),
              tabsContent.add(
                Center(
                  child: FutureBuilder(
                      future: loadData(f.id),
                      builder: (context,
                          AsyncSnapshot<List<GoodsData>> projectSnap) {
                        if (projectSnap.hasError) {
                          print("ERROR --- ${projectSnap.error}");
                        }

                        if (projectSnap.connectionState ==
                            ConnectionState.waiting) {
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
                                    height: index == 0
                                        ? ParametersConstants
                                            .paddingInFerstListElemetn
                                        : 0),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                  child: Goods(
                                    data: projectSnap.data[index],
                                    height: 155,
                                  ),
                                ),
                                SizedBox(
                                    height: projectSnap.data.length - 1 == index
                                        ? 80
                                        : 0),
                              ],
                            );
                          },
                        );
                      }),
                  //child: Text('Hello World!'),
                ),
              ),
            }
        });

    return DefaultTabController(
        length: tabsTitles.length,
        initialIndex: initialTab,
        child: Scaffold(
            drawer: Drawer(child: LeftMenu()),
            appBar: NextPageAppBar(
              height: ParametersConstants.appBarHeight,
              title: newTitle != null ? newTitle.title : title,
              bottom: TabBar(
                labelColor: ColorConstants.darkGray,
                unselectedLabelColor: ColorConstants.gray,
                indicatorColor: ColorConstants.red,
                indicatorWeight: 3,
                labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                isScrollable: true,
                tabs: tabsTitles,
              ),
            ),
            floatingActionButton: CartButton(),
            body: TabBarView(
              children: tabsContent,
            )));
  }
  /*
  @override
  _GoodsPageState createState() => _GoodsPageState();*/
}
/*
class _GoodsPageState extends State<GoodsPage> {


}*/
