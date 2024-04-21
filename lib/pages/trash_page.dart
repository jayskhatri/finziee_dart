import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/db_helper/trash_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/models/trash_model.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage>{
  List<TrashModel> _trash = [];
  List<CategoryModel> _categories = [];

  final CategoryController _categoryController = Get.find();
  final TrashController _trashController = Get.put(TrashController());

  @override
  void initState() {
    _getAllCategories();
    _getAllTrash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finziee Trash'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: const DrawerNavigation(),
      body: _getTrashList(),
    );
  }

  Widget _getTrashList(){
    if(_trash.isEmpty){
      return const Center(child: Text('Trash Empty'));
    }else{
      return ListView.builder(
        itemCount: _trash.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(children: [
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                tileColor: Colors.grey,
                leading: Icon(_getIconByTrashCatId(_trash[index].catId)),
                title: Text(_trash[index].description??''),
                subtitle: Text(_trash[index].amount.toString()),
                trailing: Text(_trash[index].date??DateTime.now().toString()),
                onTap: (){
                  _createDialog(context, _trash[index]);
                }
              ),
            ],
          ),
          );
        },
      );
    }
  }

   _getIconByTrashCatId(int? catId){
    var category = _categories.firstWhere((element) => element.catId == catId);
    return category.catType == 0 ? Icons.arrow_downward : Icons.arrow_upward;
  }

  void _createDialog(BuildContext context, TrashModel trashModel) {
    showDialog(
      context: context,
      builder:  (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: SizedBox(
                width: MediaQuery.of(context).size.width*0.6,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Choose Action"),
                      ],
                    ),
                  ]
                )
              ),
            );
          }
        );
      }
    );
  }

  void _getAllTrash() async{
    var trash = await _trashController.getTrash();
    setState(() {
      _trash = trash;
      print(_trash.length);
    });
  }

   void _getAllCategories() async{
    var catagories = await _categoryController.getCategories();
    setState(() {
      _categories = catagories;
    });
  }

}
