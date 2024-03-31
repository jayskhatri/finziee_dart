import 'package:finziee_dart/db_helper/db/db_helper.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:get/get.dart';


class CategoryController{
  var categoriesList = <CategoryModel>[].obs;
  var particularCategory = CategoryModel();

  Future<int> addCategory({CategoryModel? category})async{
    return await DBHelper.insertCategory(category!);
  }

  Future<List<CategoryModel>> getCategories() async {
    List<Map<String,dynamic>> categories = await DBHelper.getCategories();
    categoriesList.assignAll(categories.map((data) =>  CategoryModel.fromJson(data)).toList());
    return categoriesList;
  }

  Future<int> updateCategory({CategoryModel? category}) async {
    return await DBHelper.updateCategory(category!);
  }

  //delete full table
  void deleteAllCategories() async {
    DBHelper.deleteAllCategories();
  }

  //delete particular category
  Future<int> deleteCategory(int? id) async {
    return await DBHelper.deleteCategory(id!);
  }
}