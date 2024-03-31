import 'package:finziee_dart/pages/helper/drawer_navigation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finziee'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: DrawerNavigation(),
      body: ListView(
        children: <Widget>[
          Container(
            height: 80.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(10, (int index) {
                return Card(
                  color: Colors.blue[index * 100],
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                  ),
                );
              }),
            ),
          ),
        ],
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
