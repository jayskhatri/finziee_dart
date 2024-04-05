import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/pages/helper/create_category_dialog.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:finziee_dart/util/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  bool _isFavorite = false;
  List<CategoryModel> _categories = [];
  final CategoryController _categoryController = Get.find();

  @override
  void initState() {
    super.initState();
    _getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerNavigation(),
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return _generateItemList(index);
        },
      ),

      floatingActionButton: _createCategoryButton(context),
    );
  }

  //ui helper functions
  Card _generateItemList(int index) {
    return Card(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(int.parse('0xFF${_categories[index].catColor}')),
          child: InkWell(
            splashColor: Colors.blue[300],
            onTap: () {
              _createCategoryDialog(context, true, _categories[index]);
            },
            child: Column(children: [
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getFavoriteIcon(_categories[index]),
                      Text(
                        _categories[index].catName ?? '',
                        style: TextStyle(
                          color: Colour.colorList.entries
                            .firstWhere((entry) => entry.key == _categories[index].catColor, orElse: () => MapEntry('', 0))
                            .value == 1
                            ? Colors.white
                            : Colors.black,
                        ),
                      ),
                      _getIconBasedOnType(_categories[index].catType??0),
                  ],),
                  const SizedBox(
                    height: 6,
                  ),
              ],),
          )
        );
  }

  IconButton _getFavoriteIcon(CategoryModel categoryModel){
    if(categoryModel.catIsFav??false){
      return IconButton(onPressed: (){
        _toggleFavorite(categoryModel);
      }, icon: const Icon(Icons.star, color: Color.fromRGBO(255, 160, 0, 1)));
    }else{
      return IconButton(onPressed: (){
        _toggleFavorite(categoryModel);
      }, icon: const Icon(Icons.star_border, color: Color.fromRGBO(255, 160, 0, 1)));
    }
  }

  Icon _getIconBasedOnType(index){
    if(index == 0){
      return Icon(Icons.remove, color: getColorBasedOnType(index));
    }else{
      return Icon(Icons.add, color: getColorBasedOnType(index));
    }
  }

  dynamic getColorBasedOnType(int index) {
    return Colour.colorList.entries
                .firstWhere((entry) => entry.key == _categories[index].catColor,
                    orElse: () => MapEntry('', 0))
                .value ==
            1
        ? Colors.white
        : Colors.black;
  }

  Widget _createCategoryButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _createCategoryDialog(context, false, CategoryModel());
      },
      child: const Icon(Icons.add),
    );
  }

  void _createCategoryDialog(BuildContext context, bool isEditModeOn, CategoryModel categoryModel) {
    showDialog(
      context: context,
      builder: (context) {
        return CreateCategoryDialog(isEditModeOn: isEditModeOn, categoryModel: categoryModel, setStateInCallingPage: setState, categories: _categories,);
      },
    );
  }

  // backend db functions for category
  void _toggleFavorite(CategoryModel categoryModel) async{
    categoryModel.catIsFav = !_isFavorite;
    
    setState(() {
      _isFavorite = !_isFavorite;
    });

    await _categoryController.updateCategory(
      category: CategoryModel(
        catId: categoryModel.catId,
        catName: categoryModel.catName,
        catCount: categoryModel.catCount,
        catColor: categoryModel.catColor,
        catIsFav: _isFavorite,
        catType: categoryModel.catType,
      )
    );
    _getAllCategories();
  }


  void _getAllCategories() async{
    var catagories = await _categoryController.getCategories();
    setState(() {
      _categories = catagories;
    });
  }
}