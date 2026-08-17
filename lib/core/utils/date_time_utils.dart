
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  static String formatShortMonth(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m";
  }

  static String formatDurationDetailed(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:${twoDigitMinutes}:${twoDigitSeconds}";
  }
}
