import 'package:intl/intl.dart';

class CustomDate {
  String formattedDateTime(date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }

  String formattedDate(date) {
    return DateFormat.yMMMd().format(date);
  }

  String formattedDateOnly(date) {
    return DateFormat.MMMd().format(date);
  }

  String formattedHourOnly(date) {
    return DateFormat.Hms().add_d().format(date);
  }
}
