import 'package:finziee_dart/pages/categories_page.dart';
import 'package:finziee_dart/pages/helper/themes.dart';
import 'package:finziee_dart/pages/home_page.dart';
import 'package:finziee_dart/pages/recurring_page.dart';
import 'package:finziee_dart/pages/settings_page.dart';
import 'package:finziee_dart/pages/transaction_page.dart';
import 'package:finziee_dart/services/ThemeServices.dart';
import 'package:finziee_dart/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await GetStorage.init();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/recurring',
          theme: Themes.light,
          darkTheme: Themes.dark,
          themeMode: ThemeServices().theme,
          routes: {
            '/': (context) => const HomePage(),
            '/transactions':(context) =>  const TransactionPage(),
            '/categories':(context) =>  const CategoriesPage(),
            '/settings' :(context) => const SettigsPage(),
            '/recurring':(context) => const RecurringPage(),
          },
      );
  }
}