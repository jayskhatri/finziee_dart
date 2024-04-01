import 'package:finziee_dart/db_helper/category_db_controller.dart';
import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:finziee_dart/pages/transaction_page.dart';
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
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void someMethod() {
    print('Floating action button pressed');
  }
}
