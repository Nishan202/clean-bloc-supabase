import 'package:intl/intl.dart';

String dateFormatter(DateTime date) {
  return DateFormat('d MMM yyyy').format(date);
}
