import 'dart:ffi';

import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/db_helper/transaction_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/models/transaction_model.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:finziee_dart/pages/helper/select_category_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  List<TransactionModel> _transactions = [];

  final CategoryController _categoryController = Get.find();
  final TransactionController _transactionController = Get.put(TransactionController());
  final TextEditingController _selectedCategoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  int selectedCategoryIndex = 0;

  @override
  void initState() {
    _getAllCategories();
    _getAllTransactions();
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
      body: _getTransactionsList(),
      floatingActionButton: _addTransactionFloatingButton(context, false),
    );
  }

  Widget _getTransactionsList(){
    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(children: [
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              tileColor: _getColorByTransactionId(_transactions[index].catId),
              leading: Icon(_getIconByTransactionById(_transactions[index].catId)),
              title: Text(_transactions[index].description??''),
              subtitle: Text(_transactions[index].amount.toString()),
              trailing: Text(_transactions[index].date??DateTime.now().toString()),
              onTap: (){
                _createTransactionDialog(context, true, _transactions[index]);
              }
            ),
          ],
        ),
        );
      },
    );
  }
 
  Widget _addTransactionFloatingButton(BuildContext context, bool isEdit){
    return FloatingActionButton(
      onPressed: () {
        _createTransactionDialog(context, false, TransactionModel());
      },
      child: const Icon(Icons.add),
    );
  }

  _getIconByTransactionById(int? catId){
    var category = _categories.firstWhere((element) => element.catId == catId);
    return category.catType == 0 ? Icons.arrow_downward : Icons.arrow_upward;
  }

  _getColorByTransactionId(int? catId){
     var category = _categories.firstWhere((element) => element.catId == catId);
     return Color(int.parse('0xFF${category.catColor}'));
  }  
  
  void _createTransactionDialog(BuildContext context, bool isEdit, TransactionModel transactionModel) {
    initialiseVariables(isEdit, transactionModel);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: SizedBox(
                width: MediaQuery.of(context).size.width*0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      Visibility(
                        visible: isEdit,
                        child: IconButton(
                          onPressed: () {
                            _deleteTransaction(transactionModel.id??0);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ],
                  ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(20.0)),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      // onChanged: (value) {
                      //   setState(() {
                      //     _description = value;
                      //   });
                      // },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder( borderRadius: BorderRadius.circular(20.0)),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      // onChanged: (value) {
                      //   setState(() {
                      //     _amount = double.parse(value);
                      //   });
                      // },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      readOnly: true,
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((dateTime) {
                          if (dateTime != null) {
                             setState(() {
                             _dateController.text = DateFormat('yyyy-MM-dd').format(dateTime);
                              // _date =  DateFormat('yyyy-MM-dd').format(dateTime);
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: _selectedCategoryController,
                            onTap: () => _dialogBox(context, setState),
                            decoration: InputDecoration(
                              labelText: 'Select Category',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                              contentPadding: const EdgeInsets.all(10.0),
                            ),
                          ),
                         ),
                         const SizedBox(width: 10.0),
                        _getIconWidget(),
                      ],  
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
                      child: (isEdit)? const Text('Update') : const Text('Create'),
                      onPressed: (){
                        if(!isEdit) {
                          _createTransaction();
                        } else {
                          transactionModel.description = _descriptionController.text;
                          transactionModel.amount = double.parse(_amountController.text);
                          transactionModel.date = _dateController.text;
                          transactionModel.catId = _selectedCategoryController.text.isEmpty ? 1 : _categories[selectedCategoryIndex].catId;
                          _updateTransaction(transactionModel);
                        }
                        resetVariables();
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


  void _deleteTransaction(int transactionId) async {
      await _transactionController.deleteTransaction(transactionId);
      _getAllTransactions();
  }

  void _updateTransaction(TransactionModel transactionModel){
    _transactionController.updateTransaction(transaction: transactionModel);
    _getAllTransactions();
  }
 
  dynamic _getIconWidget(){
    if(_categories.isEmpty){
      return const Icon(Icons.circle, color: Colors.grey);
    }else if(_categories.isNotEmpty && selectedCategoryIndex < _categories.length){
      return Icon(Icons.circle, color: Color(int.parse('0xFF${_categories[selectedCategoryIndex].catColor}')));
    }
  }

  void resetVariables(){
    _descriptionController.clear();
    _amountController.clear();
    _selectedCategoryController.clear();
  }

  void initialiseVariables(bool isEdit, TransactionModel transactionModel){
    if(isEdit){
      _descriptionController.text = transactionModel.description??'';
      _amountController.text = transactionModel.amount.toString();
      selectedCategoryIndex = _categories.indexWhere((category) => category.catId == transactionModel.catId);
      _selectedCategoryController.text = _categories[selectedCategoryIndex].catName??'';
      _dateController.text = transactionModel.date??DateFormat('yyyy-MM-dd').format(DateTime.now());
    }else{
      _descriptionController.text = '';
      _amountController.text = '';
      selectedCategoryIndex = 0;
      _selectedCategoryController.text ='';
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }
 
  void setSelectedCategoryIndex(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  dynamic _dialogBox(BuildContext context, StateSetter setState) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectCategoryDialog(categories: _categories, setStateInCallingPage: setState, setSelectedCategoryIndex: setSelectedCategoryIndex, selectedCategoryIndex: selectedCategoryIndex, selectedCategoryController: _selectedCategoryController);
      },
    );
  }

  void _getAllCategories() async{
    var catagories = await _categoryController.getCategories();
    setState(() {
      _categories = catagories;
    });
  }

  void _getAllTransactions() async{
    var transactions = await _transactionController.getTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  void _createTransaction() {
    _transactionController.addTransaction(
      transaction: TransactionModel(
        description: _descriptionController.text,
        amount: double.parse(_amountController.text), 
        date: _dateController.text,
        catId: _selectedCategoryController.text.isEmpty ? 1 : _categories[selectedCategoryIndex].catId,
        isAutoAdded: 0,
      )
    );
    _getAllTransactions();
  }
}