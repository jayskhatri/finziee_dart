import 'dart:math';

import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:finziee_dart/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryController categoryController = Get.put(CategoryController());

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

  void someMethod() {
    print('Floating action button pressed');
  }
}
