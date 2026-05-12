import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      final absDiff = difference.abs();
      if (absDiff.inDays > 0) {
        return '${absDiff.inDays} days ago';
      } else if (absDiff.inHours > 0) {
        return '${absDiff.inHours} hours ago';
      } else if (absDiff.inMinutes > 0) {
        return '${absDiff.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } else {
      if (difference.inDays > 0) {
        return 'In ${difference.inDays} days';
      } else if (difference.inHours > 0) {
        return 'In ${difference.inHours} hours';
      } else if (difference.inMinutes > 0) {
        return 'In ${difference.inMinutes} minutes';
      } else {
        return 'Soon';
      }
    }
  }

  static String timeUntilLaunch(DateTime launchDate) {
    final now = DateTime.now();
    final difference = launchDate.difference(now);

    if (difference.isNegative) {
      return 'Launch completed';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    if (days > 0) {
      return '$days days, $hours hours';
    } else if (hours > 0) {
      return '$hours hours, $minutes minutes';
    } else if (minutes > 0) {
      return '$minutes minutes, $seconds seconds';
    } else {
      return '$seconds seconds';
    }
  }
}