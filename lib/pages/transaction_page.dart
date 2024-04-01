import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {

  List<CategoryModel> _categories = [];
  final CategoryController _categoryController = Get.find();
  final TextEditingController controller_date = TextEditingController();
  final TextEditingController controller_category = TextEditingController();


  @override
  void initState() {
    print('Transaction Page');
    // super.initState();
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
    DateTime selectedDate = DateTime.now();
    List<CategoryModel> _categories = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Transaction' : 'Add Transaction'),
          // content: _buildView(context),
          content: Container(
            height: 300,
            child: Column(
              children: <Widget>[
                const TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                const TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: controller_date,
                  decoration: const InputDecoration(labelText: 'Date'),
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
                        });
                      }
                    });
                  },
                ),
                TextField(
                  controller: controller_category,
                  decoration: InputDecoration(labelText: 'Select Category'),
                  onTap: () => _dialogBox(context),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  dynamic _dialogBox(BuildContext context){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: _buildView(context),
        );
      },
    );
  }
  Widget _buildView(BuildContext context){
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];
    String selectedItem = '';
    _getAllCategories();
    return SizedBox(
      width: double.maxFinite,
      child:ListView.separated(
        shrinkWrap: true,
        itemCount: _categories.length,
        // itemBuilder: (context, index) => Text(entries[index]),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              // color: Colors.amber[colorCodes[index]],
              // child: Text(entries[index]),
              leading: Icon(_categories[index].catType == 0 ? Icons.arrow_downward : Icons.arrow_upward),
              tileColor: Color(int.parse('0xFF${_categories[index].catColor}')),
              title: Text(_categories[index].catName.toString()),
              onTap: () {
                // Handle item selection here
                selectedItem = _categories[index].catName.toString();
                controller_category.text = selectedItem;
                Navigator.of(context).pop();
              },
            ),
          );
        },
        // separatorBuilder: (BuildContext context, int index) => const Divider(),
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
}