import 'package:finziee_dart/services/ThemeServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettigsPage extends StatefulWidget {
  const SettigsPage({super.key});

  @override
  State<SettigsPage> createState() => _SettigsPageState();
}

class _SettigsPageState extends State<SettigsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0.0,
        leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          print('clicked');
          // NotificationCreationMethod.raiseSimpleNotification(
          //     title: "Changed theme",
          //     body: Get.isDarkMode
          //         ? "Light Theme Activated"
          //         : "Dark Theme Activated");
        },
        child: Icon(
          Get.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          size: 20,
        ),
      ),
      ),
      body: const Center(child: Text('Settings mode')),
    );
  }
}