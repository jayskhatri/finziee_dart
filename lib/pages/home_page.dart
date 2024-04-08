import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/db_helper/recurrence_db_controller.dart';
import 'package:finziee_dart/db_helper/transaction_db_controller.dart';
import 'package:finziee_dart/models/recurrence_model.dart';
import 'package:finziee_dart/models/transaction_model.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:finziee_dart/services/notification_service.dart';
import 'package:finziee_dart/util/value_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryController _categoryController = Get.put(CategoryController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(NotificationService().notificationAllowed){
      TimeOfDay notificationTiming = NotificationService().notificationTime;
      NotificationService().turnOnNotifications(true, notificationTiming);
      print('Generated notifications for the next 14 days');
    }
  }
  final RecurrenceController _recurrenceController = Get.put(RecurrenceController());
  final TransactionController _transactionController = Get.put(TransactionController());
  final List<RecurrenceModel> _recurrences = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(NotificationService().notificationAllowed){
      TimeOfDay notificationTiming = NotificationService().notificationTime;
      NotificationService().turnOnNotifications(true, notificationTiming);
      print('Generated notifications for the next 14 days');
    }
    getUpcomingRecurrences();
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
        child: Text('Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context,'/transactions');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void getUpcomingRecurrences() async {
    _recurrences.clear();
    DateTime now = DateTime.now();
    DateTime lastYearNow = DateTime(now.year - 1, now.month, now.day);
    var recurrences = await _recurrenceController.getUpcomingRecurrentTransactions(lastYearNow, now);
    setState(() {
      _recurrences.addAll(recurrences);
    });
    print('fetched recurrences:');
    for (var recurrence in _recurrences) {
      print(recurrence.toJson());
      //add transaction from recurrence and then update recurrence with the next recurOn date
      await _transactionController.addTransaction(transaction: TransactionModel(
        description: recurrence.recurNote,
        amount: double.parse(recurrence.recurAmount ?? '0'),
        date: recurrence.recurOn,
        catId: recurrence.recurCatId,
        isAutoAdded: 1,
      ));

      await _recurrenceController.updateRecurringTransaction(recurringTransaction: RecurrenceModel(
        recurId: recurrence.recurId,
        recurAmount: recurrence.recurAmount,
        recurCatId: recurrence.recurCatId,
        recurNote: recurrence.recurNote,
        recurType: recurrence.recurType,
        recurOn: ValueHelper().getNextRecurringDate(recurrence),
        recurOnLabel: recurrence.recurOnLabel,
        recurShown: recurrence.recurShown,
      ));
    }
  }
}
