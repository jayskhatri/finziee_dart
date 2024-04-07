import 'package:finziee_dart/services/ThemeServices.dart';
import 'package:finziee_dart/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationAllowed = NotificationService().notificationAllowed;
  TextEditingController _notificationTimeController = TextEditingController();
  String time = NotificationService().notificationHr.toString() + ":" + NotificationService().notificationMin.toString();
  

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
      body: Column(
        children: [
          ListTile(
            title: const Text('Allow Notifications'),
            trailing: Switch(
              value: notificationAllowed, // Replace with your variable to control the switch
              onChanged: (value) {
                setState(() {
                  notificationAllowed = value;
                });
                if(notificationAllowed){
                  NotificationService().turnOnNotifications(true, TimeOfDay(hour: 20, minute: 0));
                }else{
                  NotificationService().turnOffNotifications(false);
                }
              },
            ),
          ),
          Visibility(
            visible: notificationAllowed,
            child: ListTile(
              title: const Text('Notification Time'),
              trailing: TextButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: NotificationService().notificationHr, minute: NotificationService().notificationMin),
                  );
                  if (pickedTime != null) {
                    if(notificationAllowed){
                      NotificationService().turnOnNotifications(true, pickedTime);
                    }
                    setState(() {
                      _notificationTimeController.text = pickedTime.format(context);
                    });
                  }
                },
                child: Text(_notificationTimeController.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
