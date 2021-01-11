import 'package:flutter/material.dart';
import 'package:flutter_cheez/Resources/Constants.dart';
import 'package:flutter_cheez/Resources/Models.dart';
import 'package:flutter_cheez/Resources/Resources.dart';
import 'package:flutter_cheez/Widgets/Components/category_widget.dart';
import 'package:flutter_cheez/Widgets/Forms/Forms.dart';
import 'package:flutter_cheez/Widgets/Forms/Goods.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = "";
  var _scrollController = ScrollController();
  var _currentPage = 1;
  var isLoading = false;

  List<CategoryData> categories = [];
  List<GoodsData> products = [];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!isLoading &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100) {
        loadData();
      }
    });
  }

  void loadData() {
    setState(() {
      isLoading = true;
      _currentPage++;
    });
    Resources().search(_searchQuery, _currentPage).then((value) {
      setState(() {
        products.addAll(value["products"]);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 35,
                      child: TextField(
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        cursorColor: ColorConstants.red,
                        decoration: InputDecoration(
                          hintText: "Поиск по каталогу",
                          hintStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          contentPadding:
                              EdgeInsets.only(left: 16, right: 16, top: 16),
                          fillColor: Colors.grey[300],
                        ),
                        onChanged: (value) {
                          if (value.length >= 3) {
                            setState(() {
                              _searchQuery = value.trim();
                              isLoading = true;
                              _currentPage = 1;
                            });

                            Resources()
                                .search(_searchQuery, _currentPage)
                                .then((value) {
                              setState(() {
                                categories = value["categories"];
                                products = (value["products"]);
                                isLoading = false;
                              });
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  FlatButton(
                    child: CustomText.red12px("Отмена"),
                    textColor: ColorConstants.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Column(
                      children: List.generate(
                        categories.length,
                        (index) {
                          return CategoryWidget(
                              title: categories[index].title,
                              image: categories[index].imageUrl);
                        },
                      ),
                    ),
                    Column(
                      children: List.generate(
                        products.length,
                        (index) {
                          return Column(
                            children: [
                              SizedBox(height: 15),
                              Goods(
                                data: products[index],
                                height: 155,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    if (isLoading)
                      Container(
                        width: 20,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
