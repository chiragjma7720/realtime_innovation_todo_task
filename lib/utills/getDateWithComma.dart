import 'package:intl/intl.dart';

import '../constants/string.dart';

String getDateWithComma(String dateStr)
{
  DateTime formattedDate = DateFormat(dateFormat2).parse(dateStr.toString());
  String date = DateFormat('d MMM, yyyy').format(formattedDate);
  return date;
}