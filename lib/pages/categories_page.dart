import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/pages/components/selectable_button.dart';
import 'package:flutter/material.dart';
import 'package:finziee_dart/util/color.dart';
import 'package:get/get.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  final TextEditingController _categoryNameController = TextEditingController();
  int _colorIndex = 0;
  bool _isFavorite = false;
  bool _isExpense = true;
  List<CategoryModel> _categories = [];
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    _getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  //ui widgets related helper functions
  Card _generateItemList(int index) {
    return Card(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(int.parse('0xFF${_categories[index].catColor}')),
          child: InkWell(
            splashColor: Colors.red,
            onTap: () {
              _createCategoryDialog(context, true, _categories[index]);
            },
            child: Column(children: [
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getFavoriteIcon(_categories[index]),
                      Text(_categories[index].catName??''),
                      _getIconBasedOnType(_categories[index].catType??0),
                  ],),
                  SizedBox(
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
      }, icon: Icon(Icons.star, color: Color.fromRGBO(255, 160, 0, 1)));
    }else{
      return IconButton(onPressed: (){
        _toggleFavorite(categoryModel);
      }, icon: Icon(Icons.star_border, color: Color.fromRGBO(255, 160, 0, 1)));
    }
  }

  Icon _getIconBasedOnType(index){
    if(index == 0){
      return const Icon(Icons.remove);
    }else{
      return const Icon(Icons.add);
    }
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
    //set all attributes from categoryModel if edit mode is on
    if(isEditModeOn){
      _categoryNameController.text = categoryModel.catName??'';
      _colorIndex = Colour.colorList.keys.toList().indexOf(categoryModel.catColor??'');
      _isFavorite = categoryModel.catIsFav??false;
      _isExpense = categoryModel.catType == 0 ? true : false;
    }
    
    showDialog(
      context: context,
      builder: (context) {
        bool expense = _isExpense, income = !_isExpense;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteCategory(id: categoryModel.catId??-1);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableButton(
                        selected: expense,
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.white;
                              }
                              return null; // defer to the defaults
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              print(states);
                              if (states.contains(MaterialState.selected)) {
                                return Colors.indigo;
                              }
                              return null; // defer to the defaults
                            },
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpense = !_isExpense;
                            expense = !expense;
                            income = !income;
                          });
                        },
                        child: const Text('Expense'),
                      ),
                      SelectableButton(
                        selected: income,
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.white;
                              }
                              return null; // defer to the defaults
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.indigo;
                              }
                              return null; // defer to the defaults
                            },
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpense = !_isExpense;
                            expense = !expense;
                            income = !income;
                          });
                        },
                        child: const Text('Income'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width*0.6,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Colour.colorList.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _colorIndex = index;
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Color(int.parse('0xFF${Colour.colorList.keys.elementAt(index)}')),
                                  shape: BoxShape.circle,
                                )
                              ),
                            ),
                          );
                      }),
                    ),
                    CheckboxListTile(
                      title: const Text("Favorite Category"),
                      value: _isFavorite,
                      onChanged: (newValue) {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  
                    )
                ],
              ),
              
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if(isEditModeOn){
                      _updateCategory(categoryModel);
                    }else{
                      _createCategory();
                    }
                    //set all attributes to default/empty
                    _categoryNameController.clear();
                    _colorIndex = 0;
                    _isFavorite = false;
                    _isExpense = true;
                    Navigator.of(context).pop();
                  },
                  child: Text(isEditModeOn ? 'Update' : 'Create'),
                ),
              ],
            );
          });
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

  void _createCategory() {
    // _categoryController.deleteAllCategories();
    _categoryController.addCategory(
      category: CategoryModel(
        catName: _categoryNameController.text,
        catCount: 0,
        catColor: Colour.colorList.keys.elementAt(_colorIndex),
        catIsFav: _isFavorite,
        catType: _isExpense ? 0 : 1,
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

  void _updateCategory(CategoryModel categoryModel) async{
    await _categoryController.updateCategory(
      category: CategoryModel(
        catId: categoryModel.catId,
        catName: _categoryNameController.text,
        catCount: categoryModel.catCount,
        catColor: Colour.colorList.keys.elementAt(_colorIndex),
        catIsFav: _isFavorite,
        catType: _isExpense ? 0 : 1,
      )
    );
    _getAllCategories();
  }

  void _deleteCategory({required int id}) async {
    if(id == -1){
      return;
    }
    await _categoryController.deleteCategory(id);
    _getAllCategories();
  }
}