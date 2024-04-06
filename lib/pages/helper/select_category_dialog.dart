import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/pages/helper/create_category_dialog.dart';
import 'package:finziee_dart/util/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCategoryDialog extends StatefulWidget {
  final List<CategoryModel> categories;
  final Function setStateInCallingPage;
  final Function setSelectedCategoryIndex;
  final int selectedCategoryIndex;
  final TextEditingController selectedCategoryController;

  const SelectCategoryDialog({super.key, required this.categories, required this.setStateInCallingPage, required this.setSelectedCategoryIndex, required this.selectedCategoryIndex, required this.selectedCategoryController});

  @override
  State<SelectCategoryDialog> createState() => _SelectCategoryDialogState(categories: categories, setStateInCallingPage: setStateInCallingPage, selectedCategoryIndex: selectedCategoryIndex, selectedCategoryController: selectedCategoryController, setSelectedCategoryIndex: setSelectedCategoryIndex);
}

class _SelectCategoryDialogState extends State<SelectCategoryDialog> {
  List<CategoryModel> categories;
  int selectedCategoryIndex;
  Function setStateInCallingPage;
  Function setSelectedCategoryIndex;
  final CategoryController _categoryController = Get.find();

  TextEditingController selectedCategoryController;

  _SelectCategoryDialogState({required this.categories, required this.setStateInCallingPage, required this.selectedCategoryIndex, required this.selectedCategoryController, required this.setSelectedCategoryIndex});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
          title: const Text('Select Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(child: _buildView(context, setState)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        leading: const Icon(Icons.add),
                        title: const Text('Add Category'),
                        onTap: () {
                          //add category dialog box open
                          showDialog(
                            context: context,
                            builder: (context) {
                                return CreateCategoryDialog(isEditModeOn: false, categoryModel: CategoryModel(), setStateInCallingPage: setStateInCallingPage, categories: categories);
                            });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        }
    );
  }

  Widget _buildView(BuildContext context, StateSetter setState) {
    _getCategories();
    return SizedBox(
      width: double.maxFinite,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: categories.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5.0,
            color: Color(int.parse('0xFF${categories[index].catColor}')),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              leading: Icon(categories[index].catType == 0
                  ? Icons.arrow_downward
                  : Icons.arrow_upward, color: getColorBasedOnType(index)),
              title: Text(
                categories[index].catName.toString(),
                style: TextStyle(
                  color: getColorBasedOnType(index),
                ),
              ),
              onTap: () {
                setState(() {
                  selectedCategoryIndex = index;
                  selectedCategoryController.text = categories[index].catName.toString();
                });
                setSelectedCategoryIndex(index);
                print('selected : ${selectedCategoryController.text}');
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }

  dynamic getColorBasedOnType(int index) {
    return Colour.colorList.entries
                .firstWhere((entry) => entry.key == categories[index].catColor,
                    orElse: () => MapEntry('', 0))
                .value ==
            1
        ? Colors.white
        : Colors.black;
  }


  void _getCategories() async{
    var catagory = await _categoryController.getCategories();
    setStateInCallingPage(() {
      categories = catagory;
    });
  }
}