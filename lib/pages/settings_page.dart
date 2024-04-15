import 'package:finziee_dart/services/settings_provider.dart';
import 'package:finziee_dart/services/shared_pref.dart';
import 'package:finziee_dart/util/value_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  SettingsProvider settingPrvdr = Get.find();
  bool notificationAllowed = SharedPref().notificationAllowed;
  final TextEditingController _notificationTimeController = TextEditingController();
  final ValueHelper valueHelper = ValueHelper();
  bool cFAllowed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     _notificationTimeController.text = valueHelper.getFormattedTimeIn12Hr(SharedPref().notificationTime);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
        builder: (context, SettingsProvider settingsProvider, child) {
          cFAllowed = settingsProvider.isCFAllowed??false;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () {
              settingsProvider.isDarkMode
                  ? settingsProvider.isDark = false
                  : settingsProvider.isDark = true;
            },
            child: Icon(
              settingsProvider.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
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
                  if (notificationAllowed) {
                    SharedPref().turnOnNotifications(
                        true, TimeOfDay(hour: 20, minute: 0));
                  } else {
                    _notificationTimeController.text = valueHelper
                        .getFormattedTimeIn12Hr(TimeOfDay(hour: 20, minute: 0));
                    SharedPref().turnOffNotifications(false);
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
                      initialTime: SharedPref().notificationTime,
                    );
                    if (pickedTime != null) {
                      if (SharedPref().notificationAllowed) {
                        SharedPref().turnOnNotifications(true, pickedTime);
                      }
                      setState(() {
                        _notificationTimeController.text =
                            pickedTime.format(context);
                      });
                    }
                  },
                  child: Text(_notificationTimeController.text),
                ),
              ),
            ),
            ListTile(
              title: const Text('Allow Carry Forward'),
              trailing: Switch(
                value: settingsProvider
                    .isCFAllowed, // Replace with your variable to control the switch
                onChanged: (value) {
                  print('value is: $value');
                  setState(() {
                    cFAllowed = value;
                  });
                  print('CF Allowed: $cFAllowed');
                  settingsProvider.isCFAllowed = cFAllowed;
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
