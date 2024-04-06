import 'dart:ffi';

import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/db_helper/transaction_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/models/transaction_model.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_calculator/flutter_calculator.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<CategoryModel> _categories = [];
  List<String?> _categoryColors = [];
  List<TransactionModel> _transactions = [];
  CategoryModel _categoryModel  = Get.put(CategoryModel());
  final CategoryController _categoryController = Get.find();
  final TextEditingController controller_date = TextEditingController();
  final TextEditingController controller_category = TextEditingController();
  final TransactionController _transactionController = Get.put(TransactionController());
  CategoryModel _mySelectedCat = CategoryModel(catColor: "EF5350");
  double _amount = 0.0;
  String _date = " ";
  String _description = '';


  @override
  void initState() {
    _getAllCategories();
    _getAllTransactions(context, setState);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finziee Transactions'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: const DrawerNavigation(),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Color(int.parse('0xFF${_getCategoryColor(_transactions[index].catId)}')),
            child: ListTile(
              title: Text(_transactions[index].description.toString()),
              subtitle: Text(_transactions[index].date.toString()),
              trailing: Text(_transactions[index].amount.toString()),
              leading: Icon(
                _getIconByTransactionById(_transactions[index].catId)
              ),
            ),
          );
        },
      ),
      floatingActionButton: _addTransactionFloatingButton(context, false),
    );
  }

  _getIconByTransactionById(int? catId){
    var category = _categories.firstWhere((element) => element.catId == catId);
    return category.catType == 0 ? Icons.arrow_downward : Icons.arrow_upward;
  }

  String? _getCategoryColor(int? catId){  
    var category = _categories.firstWhere((element) => element.catId == catId);
    return category.catColor;
  }
  
  Widget _addTransactionFloatingButton(BuildContext context, bool isEdit){
    return FloatingActionButton(
      onPressed: () {
        _createTransactionDialog(context, false);
      },
      child: const Icon(Icons.add),
    );
  }

  void _createTransactionDialog(BuildContext context, bool isEdit) {
    DateTime selectedDate = DateTime.now();
   
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit Transaction' : 'Add Transaction'),
              content: SizedBox(
                height: 225,
                width: MediaQuery.of(context).size.width*0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(20.0)),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(20.0)),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        setState(() {
                          _amount = double.parse(value);
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      readOnly: true,
                      controller: controller_date,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((dateTime) {
                          if (dateTime != null) {
                            setState(() {
                              selectedDate = dateTime;
                              controller_date.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                              _date =  controller_date.text;
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      readOnly: true,
                      controller: controller_category,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.circle,
                          color: Color(int.parse('0xFF${_mySelectedCat.catColor}')),
                        ),
                        labelText: 'Select Category',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      onTap: () => _dialogBox(context, setState),
                    ),
                  ],
                ), 
              ),
              actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Create'),
                      onPressed: (){
                        _createTransaction();
                        Navigator.of(context).pop();
                      }
                    )
                  ],
            );
          }
        );
      },
    );
  }

  dynamic _dialogBox(BuildContext context, StateSetter setState){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: _buildView(context, TransactionModel(), setState),
        );
      },
    );
  }
  Widget _buildView(BuildContext context, TransactionModel transaction, StateSetter setState){
    String selectedItem = '';
    _getAllCategories();
    return SizedBox(
      width: double.maxFinite,
      child:ListView.separated(
        shrinkWrap: true,
        itemCount: _categories.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              leading: Icon(_categories[index].catType == 0 ? Icons.arrow_downward : Icons.arrow_upward),
              tileColor: Color(int.parse('0xFF${_categories[index].catColor}')),
              title: Text(_categories[index].catName.toString()),
              onTap: () {
                selectedItem = _categories[index].catName.toString();
                _mySelectedCat =  _categories[index];
                controller_category.text = selectedItem;
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }

  //all db function
    void _getAllCategories() async{
    var catagories = await _categoryController.getCategories();
    setState(() {
      _categories = catagories;
    });
  }
  void _getAllTransactions(context, StateSetter setStage) async{
    var transactions = await _transactionController.getTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  
  void _createTransaction() {
    _transactionController.addTransaction(
      transaction: TransactionModel(
        description: _description,
        amount: _amount, 
        date: _date,
        catId: _mySelectedCat.catId,
        isAutoAdded: 0,
      )
    );
    print(_transactionController.transactionsList.length);
    _getAllCategories();
  }
}