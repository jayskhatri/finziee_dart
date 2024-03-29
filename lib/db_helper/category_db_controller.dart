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
    return await DBHelper.getCategories();
  }
}