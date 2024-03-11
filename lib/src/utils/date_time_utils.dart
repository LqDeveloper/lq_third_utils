import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

/// 处理时间的工具类
class DateTimeUtils {
  DateTimeUtils._();

  ///将Date字符串转为DateTime
  static DateTime? parse(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return null;
    }
    return Jiffy.parse(dateStr).dateTime;
  }

  ///时间格式化
  static String? formatDate(DateTime? dateTime, {required String format}) {
    if (dateTime == null) {
      return null;
    }
    return DateFormat(format).format(dateTime);
  }

  ///时间格式化字符串
  static String? formatDateStr(String? dateStr, {required String format}) {
    final dateTime = parse(dateStr);
    return formatDate(dateTime, format: format);
  }

  ///时间格式化
  static String? format(String? dateStr, {required String format}) {
    if (dateStr == null || dateStr.isEmpty) {
      return null;
    }
    return Jiffy.parse(dateStr).format(pattern: format);
  }

  ///自“Unix 纪元”1970-01-01T00：00：00Z （UTC） 以来的毫秒数。
  static int millisecondsSinceEpoch(String? dateStr) {
    return parse(dateStr)?.millisecondsSinceEpoch ?? 0;
  }

  ///时间字符串是位于第几季度
  static int quarter(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 0;
    }
    return Jiffy.parse(dateStr).quarter;
  }

  ///返回值是介于 1 和 7 之间的整数，其中 1 表示 一周的第一天
  static int dayOfWeek(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 0;
    }
    return Jiffy.parse(dateStr).dayOfWeek;
  }

  ///返回时间字符串中的月总共有多少天
  static int daysInMonth(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 0;
    }
    return Jiffy.parse(dateStr).daysInMonth;
  }

  ///返回时间字符串是一年中的第几天
  static int dayOfYear(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 0;
    }
    return Jiffy.parse(dateStr).dayOfYear;
  }

  ///返回时间字符串位于一年中的第几周
  static int weekOfYear(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 0;
    }
    return Jiffy.parse(dateStr).weekOfYear;
  }

  ///时间相加
  static DateTime? addDuration(String? dateStr, {required Duration duration}) {
    if (dateStr == null || dateStr.isEmpty) {
      return null;
    }
    return Jiffy.parse(dateStr).addDuration(duration).dateTime;
  }

  ///时间相减
  static DateTime? subtractDuration(String? dateStr,
      {required Duration duration}) {
    if (dateStr == null || dateStr.isEmpty) {
      return null;
    }
    return Jiffy.parse(dateStr).subtractDuration(duration).dateTime;
  }
}
