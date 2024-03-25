import 'package:intl/intl.dart';

String formatDatebydMMMyyyy(DateTime dateTime) {
  return DateFormat('d MMM, yyyy').format(dateTime);
}
