import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finziee'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: DrawerNavigation(),
      body: const Center(
        child: Text('Welcome to Finziee'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: someMethod,
        child: const Icon(Icons.add),
      ),
    );
  }

  void someMethod() {
    print('Floating action button pressed');
  }
}