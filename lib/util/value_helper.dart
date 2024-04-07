
import 'package:flutter/material.dart';

class ValueHelper{
  
  String getFormattedTimeIn12Hr(TimeOfDay time) {
    int hour = time.hourOfPeriod;
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    if(hour > 12){
      hour -= 12;
    }
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  TimeOfDay getTimeOfDayFromString(String timeString) {
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    if (parts[1].toLowerCase() == 'pm' && hour != 12) {
      hour += 12;
    } else if (parts[1].toLowerCase() == 'am' && hour == 12) {
      hour = 0;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }
}