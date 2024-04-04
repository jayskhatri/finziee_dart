import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/db_helper/recurrence_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/models/recurrence_model.dart';
import 'package:finziee_dart/pages/helper/create_category_dialog.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecurringPage extends StatefulWidget {
  const RecurringPage({super.key});

  @override
  State<RecurringPage> createState() => _RecurringPageState();
}

class _RecurringPageState extends State<RecurringPage> {
  List<RecurrenceModel> _recurrences = [];
  List<CategoryModel> _categories = [];
  final RecurrenceController _recurrenceController = Get.put(RecurrenceController());
  final CategoryController _categoryController = Get.find();

  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat('d');
  DateFormat monthFormat = DateFormat('MMMM');
  DateFormat yearFormat = DateFormat('yyyy');
  DateFormat dayFormat = DateFormat('EEEE');
      

  final TextEditingController _selectedCategoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _recurAmountController = TextEditingController();
  final TextEditingController _recurNoteController = TextEditingController();
  final TextEditingController _dayMonthController = TextEditingController();

  int selectedCategoryIndex = 0;
  final List<String> _recurTypes = ["Daily", "Weekly", "Monthly", "Yearly"];
  String recurTypeDropdownValue = 'Daily';
  String dayDropDown = 'Monday';
  String dateDropDown = '1';
  String dayYearlyDropdown = '1';
  String monthYearlyDropdown = 'January';
  final List<String> _choicesWeekly = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final List<String> _choicesMonthly = List.generate(31, (index) => (index + 1).toString());
  final List<String> _choicesMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final TextEditingController _recurTimePickerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getRecurringTransactions();
    _getCategories();
  }

  void updateCategoriesLocally(List<CategoryModel> categories) {
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring'),
      ),
      drawer: const DrawerNavigation(),
      body: ListView.builder(
          itemCount: _recurrences.length,
          itemBuilder: (context, index) {
            return _generateRecurringItemList(index);
          }),
      floatingActionButton: _createRecurringTransactionButton(context, false),
    );
  }

  Card _generateRecurringItemList(int index) {
    return const Card();
  }

  FloatingActionButton _createRecurringTransactionButton(
      BuildContext context, bool isEdit) {
    return FloatingActionButton(
      onPressed: () {
        _generateAddRecurringTransactionDialog(context, isEdit);
      },
      child: const Icon(Icons.add),
    );
  }

  void _generateAddRecurringTransactionDialog(BuildContext context, bool isEdit) {
    
    DateTime selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    recurTypeDropdownValue = 'Daily';
    _recurAmountController.text = '';
    _recurNoteController.text = '';
    _selectedCategoryController.text = '';
    dateDropDown = dateFormat.format(now);
    dayYearlyDropdown = dateFormat.format(now);
    monthYearlyDropdown = monthFormat.format(now);
    selectedCategoryIndex = 0;
    _recurTimePickerController.text = '10:00 PM';//TimeOfDay.now().format(context);
    _dayMonthController.text = dayYearlyDropdown + ' ' + monthYearlyDropdown;


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
          return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (isEdit) {
                    print('Data in update mode:');
                    print('_recurAmountController: ${_recurAmountController.text}');
                    print('_recurNoteController: ${_recurNoteController.text}');
                    print('_selectedCategoryController: ${_selectedCategoryController.text}');
                    print('_recurTimePickerController: ${_recurTimePickerController.text}');

                    print('Data in variables:');
                    print('selectedDate: $selectedDate');
                    print('recurTypeDropdownValue: $recurTypeDropdownValue');
                    print('selectedCategoryIndex: $selectedCategoryIndex');
                    print('dateDropDown: $dateDropDown');
                    print('dayYearlyDropdown: $dayYearlyDropdown');
                    print('monthYearlyDropdown: $monthYearlyDropdown');
                  
                  // _updateRecurringTransaction(RecurrenceModel(
                  //   recurAmount: _recurAmountController.text,
                  //   recurNote: _recurNoteController.text,
                  //   recurCatId: _categories[selectedCategoryIndex].catId,
                  // ));
                } else {
                    print('Data in add mode:');
                    print('_recurAmountController: ${_recurAmountController.text}');
                    print('_recurNoteController: ${_recurNoteController.text}');
                    print('_selectedCategoryController: ${_selectedCategoryController.text}');
                    print('_recurTimePickerController: ${_recurTimePickerController.text}');

                    print('Data in variables:');
                    print('selectedDate: $selectedDate');
                    print('user selected recurTypeDropdownValue: $recurTypeDropdownValue');
                    print('selectedCategoryIndex: $selectedCategoryIndex');
                    print('dateDropDown: $dateDropDown');
                    print('dayYearlyDropdown: $dayYearlyDropdown');
                    print('monthYearlyDropdown: $monthYearlyDropdown');
                  // _createRecurringTransaction();
                }
                Navigator.of(context).pop();
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
          title: Text(isEdit ? 'Edit Recurring' : 'Add Recurring'),
          // content: _buildView(context),
          content: SizedBox(
            width: MediaQuery.of(context).size.width*0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _recurNoteController,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    contentPadding: const EdgeInsets.all(10.0),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _recurAmountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    contentPadding: const EdgeInsets.all(10.0),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
            
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Recur Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: const EdgeInsets.all(10.0),
                        ),
                        value: _recurTypes[0],
                        items: _recurTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            recurTypeDropdownValue = value??'Daily';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    _getWidgetBasedOnRecurType(recurTypeDropdownValue, setState),
                    const SizedBox(width: 10.0,)
                  ],
                ),
                
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          hintText: 'Select a Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: const EdgeInsets.all(10.0),
                        ),
                        readOnly: true,
                        controller: _selectedCategoryController,
                        onTap: () => _dialogBox(context, setState),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    _getIconWidget(),
                  ],
                )
              ],
            ),
          ),
        );
        });
      },
    );
  }

  dynamic _getIconWidget(){
    return Icon(Icons.circle, color: Color(int.parse('0xFF${_categories[selectedCategoryIndex].catColor}')));
  }

  dynamic _getYearAndMonthDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //TODO check for validity of date here (there might be invalid combination, leap year case also)
                if(dayYearlyDropdown != '' && monthYearlyDropdown != ''){
                  _dayMonthController.text = '$dayYearlyDropdown $monthYearlyDropdown';
                }else{
                  _dayMonthController.text = '';
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
          content: SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Day',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      value: _choicesMonthly[0],
                      items: _choicesMonthly.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dayYearlyDropdown = value ?? '1';
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10.0,),
                Expanded(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                      value: _choicesMonthNames[0],
                      items: _choicesMonthNames.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          monthYearlyDropdown = value ?? 'January';
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  dynamic _getWidgetBasedOnRecurType(String recurTypeDropdownValue, StateSetter setState) {
    if (recurTypeDropdownValue == 'Daily') {
      _recurTimePickerController.text = '10:00 PM';//TimeOfDay.now().format(context);
      return Expanded(
        child: TextField(
          controller: _recurTimePickerController,
          decoration: InputDecoration(
            labelText: 'Time',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
          ),
          readOnly: true,
          // onTap: () async {
          //   TimeOfDay? pickedTime = await showTimePicker(
          //     context: context,
          //     initialTime: TimeOfDay.now(),
          //   );
          //   if (pickedTime != null) {
          //     setState(() {
          //       _recurTimePickerController.text = pickedTime.format(context);
          //     });
          //   }
          // },
        ),
      );
    } else if (recurTypeDropdownValue == 'Weekly') {
      dayDropDown = dayFormat.format(now);
      return Expanded(
        child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Day',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
          ),
          value: dayDropDown,
          items: _choicesWeekly.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              dayDropDown = value ?? 'Monday';
            });
          },
        ),
      );
    } else if (recurTypeDropdownValue == 'Monthly') {
      dateDropDown = dateFormat.format(now);  
      return Expanded(
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: 'Date',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
          ),
          value: dateDropDown,
          items: _choicesMonthly.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              dateDropDown = value ?? '1';
            });
          },
        ),
      );
    } else if (recurTypeDropdownValue == 'Yearly') {
      dayYearlyDropdown = dateFormat.format(now);
      monthYearlyDropdown = monthFormat.format(now);
      _dayMonthController.text = dayYearlyDropdown + ' ' + monthYearlyDropdown;
      return Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Day and Month',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding: const EdgeInsets.all(10.0),
            ),
            readOnly: true,
            controller: _dayMonthController,
            onTap: () {
              _getYearAndMonthDialog(context);
            },
          )
        );
    }
  }

  dynamic _dialogBox(BuildContext context, StateSetter setState) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
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
                                return CreateCategoryDialog(isEditModeOn: false, categoryModel: CategoryModel(), setStateInCallingPage: setState, categories: _categories,);
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
      },
    );
  }

  Widget _buildView(BuildContext context, StateSetter setState) {
    _getCategories();
    return SizedBox(
      width: double.maxFinite,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _categories.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5.0,
            color: Color(int.parse('0xFF${_categories[index].catColor}')),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              leading: Icon(_categories[index].catType == 0
                  ? Icons.arrow_downward
                  : Icons.arrow_upward),
              title: Text(_categories[index].catName.toString()),
              onTap: () {
                setState(() {
                  selectedCategoryIndex = index;
                  _selectedCategoryController.text = _categories[index].catName.toString();
                });
                print('selected : ${_selectedCategoryController.text}');
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }

  //db functions
  void _getRecurringTransactions() async {
    var recurrences = await _recurrenceController.getRecurringTransactions();
    setState(() {
      _recurrences = recurrences;
    });
  }

  void _getCategories() async {
    var categories = await _categoryController.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _updateRecurringTransaction(RecurrenceModel recurringTransaction) async {
    await _recurrenceController.updateRecurringTransaction(
        recurringTransaction: RecurrenceModel(
      recurId: recurringTransaction.recurId,
      recurAmount: _recurAmountController.text,
    ));
    _getRecurringTransactions();
  }

  void _createRecurringTransaction() {
    _recurrenceController.addRecurringTransaction(
        recurrence: RecurrenceModel(recurAmount: _recurAmountController.text));
    _getRecurringTransactions();
  }

  void _deleteRecurringTransaction({required int id}) async {
    if (id == -1) {
      return;
    }
    await _recurrenceController.deleteRecurringTransaction(id);
    _getRecurringTransactions();
  }
}
