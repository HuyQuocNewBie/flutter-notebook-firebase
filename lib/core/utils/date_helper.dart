import 'package:intl/intl.dart';

class DateHelper {
  static String format(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Hôm nay ${DateFormat('HH:mm').format(date)}';
    } else if (target == yesterday) {
      return 'Hôm qua ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }
}