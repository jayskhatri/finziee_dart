import 'package:finziee_dart/pages/categories_page.dart';
import 'package:finziee_dart/pages/home_page.dart';
import 'package:finziee_dart/pages/transaction_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/transactions':(context) =>  const TransactionPage(),
        '/categories':(context) =>  const CategoriesPage(),
      },
    );
  }
}