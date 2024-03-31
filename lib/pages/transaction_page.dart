import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {

  List<CategoryModel> _categories = [];
  final CategoryController _categoryController = Get.find();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllCategories();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finziee'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: const DrawerNavigation(),
      body: const Center(
        child: Text('Transaction Page'),
      ),

      floatingActionButton: _addTransactionFloatingButton(context),
    );
  }

  Widget _addTransactionFloatingButton(BuildContext context){
    return FloatingActionButton(
      onPressed: () {
        _createTransactionDialog(context, false);
      },
      child: const Icon(Icons.add),
    );
  }

  void _createTransactionDialog(BuildContext context, bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Transaction' : 'Add Transaction'),
          content: Column(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
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
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


  //all db function
    void _getAllCategories() async{
    var catagories = await _categoryController.getCategories();
    setState(() {
      _categories = catagories;
    });
  }
}