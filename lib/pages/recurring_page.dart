import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/db_helper/recurrence_db_controller.dart';
import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/models/recurrence_model.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:finziee_dart/pages/helper/select_category_dialog.dart';
import 'package:finziee_dart/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecurringPage extends StatefulWidget {
  const RecurringPage({super.key});

  @override
  State<RecurringPage> createState() => _RecurringPageState();
}

class _RecurringPageState extends State<RecurringPage> {
  List<RecurrenceModel> _recurringTransactions = [];
  List<CategoryModel> _categories = [];
  final RecurrenceController _recurrenceController = Get.put(RecurrenceController());
  final CategoryController _categoryController = Get.find();

  DateTime now = DateTime.now();

  final TextEditingController _selectedCategoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _recurAmountController = TextEditingController();
  final TextEditingController _recurNoteController = TextEditingController();
  final TextEditingController _dayMonthController = TextEditingController();

  int selectedCategoryIndex = 0;
  String recurTypeDropdownValue = 'Daily';
  String dayDropDown = 'Monday';
  String dateDropDown = '1';
  String dayYearlyDropdown = '1';
  String monthYearlyDropdown = 'January';

  final TextEditingController _recurTimePickerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getRecurringTransactions();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring'),
      ),
      drawer: const DrawerNavigation(),
      body: _generateRecurringItemList(),
      floatingActionButton: _createRecurringTransactionButton(context, false),
    );
  }

  Color _getColorFromCatType(int catId) {
    if(_categories.isEmpty || catId == -1){
      return Colors.grey;
    }
    return Color(int.parse('0xFF${_categories[_categories.indexWhere((element) => element.catId == catId)].catColor}'));
  }

  Center _generateRecurringItemList() {
    if(_recurringTransactions.isEmpty){
      return const Center(child: Text('No Recurring Transactions Found'));
    }
    return Center(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _recurringTransactions.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 20,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                color: _getColorFromCatType(_recurringTransactions[index].recurCatId??-1),
                child: InkWell(
                  splashColor: Colors.blue[300],
                  onTap: () {
                    _generateAddRecurringTransactionDialog(context, true, _recurringTransactions[index]);
                  },
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(_recurringTransactions[index].recurNote??''),
                        subtitle: Text(_recurringTransactions[index].recurAmount??''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteRecurringTransaction(id: _recurringTransactions[index].recurId??-1);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    
  }

  FloatingActionButton _createRecurringTransactionButton(
      BuildContext context, bool isEdit) {
    return FloatingActionButton(
      onPressed: () {
        _generateAddRecurringTransactionDialog(context, isEdit, RecurrenceModel());
      },
      child: const Icon(Icons.add),
    );
  }

  String getRecurrenceOnDate(){
      DateTime now = DateTime.now();
      DateTime generatedDate = now;
      String time = '10:00 PM';

      if (recurTypeDropdownValue == 'Daily') {
        generatedDate = DateTime(now.year, now.month, now.day);
      } else if (recurTypeDropdownValue == 'Weekly') {
        int selectedDayIndex = Constants.choicesWeekly.indexOf(dayDropDown);
        int daysToAdd = (selectedDayIndex - now.weekday + 7) % 7;
        generatedDate = now.add(Duration(days: (daysToAdd + 1)));
      } else if (recurTypeDropdownValue == 'Monthly') {
        int selectedDateValue = int.parse(dateDropDown);
        if (selectedDateValue < now.day) {
          generatedDate = DateTime(now.year, now.month + 1, selectedDateValue);
        } else {
          generatedDate = DateTime(now.year, now.month, selectedDateValue);
        }
      } else if (recurTypeDropdownValue == 'Yearly') {
        int selectedDateValue = int.parse(dayYearlyDropdown);
        int selectedMonthIndex = Constants.choicesMonthNames.indexOf(monthYearlyDropdown);
        generatedDate = DateTime(now.year, selectedMonthIndex + 1, selectedDateValue);
        if (generatedDate.isBefore(now)) {
          generatedDate = DateTime(now.year + 1, selectedMonthIndex + 1, selectedDateValue);
        }
      }

      String formattedDate = DateFormat('yyyy-MM-dd').format(generatedDate);
      return formattedDate + ' ' + time;
  }

  String getRecurOnValue(){
    if(recurTypeDropdownValue == 'Daily'){
      return _recurTimePickerController.text;
    }else if(recurTypeDropdownValue == 'Weekly'){
      return dayDropDown;
    }else if(recurTypeDropdownValue == 'Monthly'){
      return dateDropDown;
    }else if(recurTypeDropdownValue == 'Yearly'){
      return dayYearlyDropdown + ' ' + monthYearlyDropdown;
    }
    return '';
  }

  void _generateAddRecurringTransactionDialog(BuildContext context, bool isEdit, RecurrenceModel recurrenceModel) {
    DateTime selectedDate = DateTime.now();
    initializeControllerAndVariables(isEdit, recurrenceModel, selectedDate);
    print('recurId----> ${recurrenceModel.recurId}');

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

                    RecurrenceModel updatedRecurrenceModel = RecurrenceModel();
                    updatedRecurrenceModel.recurId = recurrenceModel.recurId;
                    updatedRecurrenceModel.recurAmount = _recurAmountController.text;
                    updatedRecurrenceModel.recurNote = _recurNoteController.text;
                    updatedRecurrenceModel.recurCatId = _categories[selectedCategoryIndex].catId;
                    updatedRecurrenceModel.recurType = Constants.recurTypes.indexOf(recurTypeDropdownValue);
                    updatedRecurrenceModel.recurOn = getRecurOnValue();
                    print('recurId: ${updatedRecurrenceModel.recurId}');
                    _updateRecurringTransaction(updatedRecurrenceModel);
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
                    print('dayDropdown in weekly: $dayDropDown');
                    print('dayYearlyDropdown: $dayYearlyDropdown');
                    print('monthYearlyDropdown: $monthYearlyDropdown');
                    print('getRecurrenceOnDate: ${getRecurrenceOnDate()}');
                    print('getRecurvalue: ${getRecurOnValue()}');
                    RecurrenceModel newRecurrenceModel = RecurrenceModel();
                    newRecurrenceModel.recurAmount = _recurAmountController.text;
                    newRecurrenceModel.recurNote = _recurNoteController.text;
                    newRecurrenceModel.recurCatId = _categories[selectedCategoryIndex].catId;
                    newRecurrenceModel.recurType = Constants.recurTypes.indexOf(recurTypeDropdownValue);
                    newRecurrenceModel.recurOn = getRecurOnValue();
                  _createRecurringTransaction(newRecurrenceModel);
                }
                resetControllerAndVariables();
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
                        value: recurTypeDropdownValue,
                        items: Constants.recurTypes.map((String value) {
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

  void resetControllerAndVariables() {
    _recurAmountController.clear();
    _recurNoteController.clear();
    _selectedCategoryController.clear();
    _recurTimePickerController.clear();
    selectedCategoryIndex = 0;
    recurTypeDropdownValue = 'Daily';
    dayDropDown = 'Monday';
    dateDropDown = '1';
    dayYearlyDropdown = '1';
    monthYearlyDropdown = 'January';
  }

  void initializeControllerAndVariables(bool isEdit, RecurrenceModel recurrenceModel, DateTime selectedDate) {
    if(isEdit){
      selectedCategoryIndex = _categories.indexWhere((category) => category.catId == recurrenceModel.recurCatId);
      _recurAmountController.text = recurrenceModel.recurAmount??'';
      _recurNoteController.text = recurrenceModel.recurNote??'';
      _selectedCategoryController.text = _categories[selectedCategoryIndex].catName ?? '';
      recurTypeDropdownValue = Constants.recurTypes[recurrenceModel.recurType??0];
      _recurTimePickerController.text = recurrenceModel.recurOn??'10:00 PM';
      
      if(recurTypeDropdownValue == 'Daily'){
        _recurTimePickerController.text = recurrenceModel.recurOn??'10:00 PM';
      }else if(recurTypeDropdownValue == 'Weekly'){
        dayDropDown = recurrenceModel.recurOn??'Monday';
      }else if(recurTypeDropdownValue == 'Monthly'){
        dateDropDown = recurrenceModel.recurOn??now.day.toString();
      }else if(recurTypeDropdownValue == 'Yearly'){
        List<String> dateAndMonth = recurrenceModel.recurOn?.split(' ')??['1', 'January'];
        dayYearlyDropdown = dateAndMonth[0];
        monthYearlyDropdown = dateAndMonth[1];
        print(dayYearlyDropdown + ' ' + monthYearlyDropdown);
        _dayMonthController.text  = dayYearlyDropdown + ' ' + monthYearlyDropdown;
      }
    }else{
      _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      recurTypeDropdownValue = 'Daily';
      _recurAmountController.text = '';
      _recurNoteController.text = '';
      _selectedCategoryController.text = '';
      dayDropDown = Constants.choicesWeekly[now.weekday-1];
      dateDropDown = Constants.dateFormat.format(now);
      dayYearlyDropdown = Constants.dateFormat.format(now);
      monthYearlyDropdown = Constants.monthFormat.format(now);
      selectedCategoryIndex = 0;
      _recurTimePickerController.text = '10:00 PM';//TimeOfDay.now().format(context);
      _dayMonthController.text = dayYearlyDropdown + ' ' + monthYearlyDropdown;
    }
  }

  dynamic _getIconWidget(){
    if(_categories.isEmpty){
      return const Icon(Icons.circle, color: Colors.grey);
    }else if(_categories.isNotEmpty && selectedCategoryIndex < _categories.length){
      return Icon(Icons.circle, color: Color(int.parse('0xFF${_categories[selectedCategoryIndex].catColor}')));
    }
  }

  dynamic _getYearAndMonthDialog(BuildContext context) {
    dayYearlyDropdown = Constants.dateFormat.format(now);
    monthYearlyDropdown = Constants.monthFormat.format(now);
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
                      value: dayYearlyDropdown,
                      items: Constants.choicesMonthly.map((String value) {
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
                      value: monthYearlyDropdown,
                      items: Constants.choicesMonthNames.map((String value) {
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

  dynamic _getWidgetBasedOnRecurType(String recurTypeDropdownValue, StateSetter setDialogState) {
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
          items: Constants.choicesWeekly.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            print('before $dayDropDown');
            setState(() {
              dayDropDown = value ?? 'Monday';
            });
            print('after $dayDropDown');
          },
        ),
      );
    } else if (recurTypeDropdownValue == 'Monthly') {
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
          items: Constants.choicesMonthly.map((String value) {
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

  //db functions
  void _getRecurringTransactions() async {
    var recurrences = await _recurrenceController.getRecurringTransactions();
    setState(() {
      _recurringTransactions = recurrences;
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
        recurringTransaction: recurringTransaction);
    _getRecurringTransactions();
  }

  void _createRecurringTransaction(RecurrenceModel recurrenceModel) {
    _recurrenceController.addRecurringTransaction(
        recurrence: recurrenceModel);
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
