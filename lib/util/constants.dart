import 'package:intl/intl.dart';

class Constants{
  static final List<String> recurTypes = ["Daily", "Weekly", "Monthly", "Yearly"];

  static final List<String> choicesWeekly = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  static final List<String> choicesMonthly = List.generate(28, (index) => (index + 1).toString());
  
  static final List<String> choicesMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static final DateFormat dateFormat = DateFormat('d');
  static final DateFormat monthFormat = DateFormat('MMMM');
  static final DateFormat yearFormat = DateFormat('yyyy');
  static final DateFormat dayFormat = DateFormat('EEEE');


}