import 'package:decimal/decimal.dart';

/// App字符串数字处理
class NumUtils {
  static Decimal tryParse(String? number) {
    if (number != null && number.isNotEmpty) {
      return Decimal.tryParse(number) ?? Decimal.zero;
    } else {
      return Decimal.zero;
    }
  }

  static Decimal tryParseDouble(double? number, {int precision = 10}) {
    if (number != null) {
      return Decimal.tryParse(number.toStringAsFixed(precision)) ??
          Decimal.zero;
    } else {
      return Decimal.zero;
    }
  }

  static double max(String? a, String? b) {
    return (tryParse(a) >= tryParse(b))
        ? tryParse(a).toDouble()
        : tryParse(b).toDouble();
  }

  static double min(String? a, String? b) {
    return (tryParse(a) < tryParse(b))
        ? tryParse(a).toDouble()
        : tryParse(b).toDouble();
  }

  static bool isZero(String? number) {
    return tryParse(number) == Decimal.zero;
  }

  static bool isNotZero(String? number) {
    return tryParse(number) != Decimal.zero;
  }

  static bool lessThan(String? a, String? b) {
    return tryParse(a) < tryParse(b);
  }

  static bool equalsThan(String? a, String? b) {
    return tryParse(a) == tryParse(b);
  }

  static bool equals(String? a, String? b) {
    return tryParse(a) == tryParse(b);
  }

  static bool isNotEquals(String? a, String? b) {
    return tryParse(a) != tryParse(b);
  }

  static String multiply(String? a, String? b) {
    return (tryParse(a) * tryParse(b)).toString();
  }

  static String multiply2Int(String? a, String? b) {
    return (tryParse(a) * tryParse(b)).toStringAsFixed(0).toString();
  }

  static String add(String? a, String? b) {
    return (tryParse(a) + tryParse(b)).toString();
  }

  static String subtract(String? a, String? b) {
    return (tryParse(a) - tryParse(b)).toString();
  }

  static String multiplyDouble(String? a, double? b) {
    return (tryParse(a) * tryParseDouble(b)).toString();
  }

  static String multiplyDouble2Int(String? a, double? b) {
    return (tryParse(a) * tryParseDouble(b)).toStringAsFixed(0).toString();
  }

  static String multiply2Double(double? a, double? b) {
    return (tryParseDouble(a) * tryParseDouble(b)).toString();
  }

  static String divide(String? a, String? b,
      {int precision = 10, String defaultResult = '0'}) {
    if (tryParse(b) == Decimal.zero) {
      return defaultResult;
    }
    final rational = (tryParse(a) / tryParse(b))
        .toDecimal(scaleOnInfinitePrecision: precision);
    return _removeInvalidZero(rational.toStringAsFixed(precision));
  }

  static String truncate(String? number, {int precision = 10}) {
    return _removeInvalidZero(tryParse(number).toStringAsFixed(precision));
  }

  static String _removeInvalidZero(String? number) {
    if (number?.isNotEmpty ?? false) {
      if (number!.contains(".")) {
        final regExp = RegExp('[1-9]');
        for (int i = number.length - 1; i >= 0; i--) {
          final String char = number!.substring(i, i + 1);
          if (char == ".") {
            number = number.replaceRange(i, i + 1, "*");
            break;
          } else if (regExp.hasMatch(char)) {
            break;
          } else {
            number = number.replaceRange(i, i + 1, "*");
          }
        }
        number = number!.replaceAll("*", "");
        return number;
      } else {
        return number;
      }
    } else {
      return "0";
    }
  }

  ///格式化，向下取 [precision] 位小数,不足不补0
  ///  final a = '1234.1234567';
  ///  print(NumUtils.toFormatDownStr(numStr: a,precision: 6));//1234.123
  ///  final b = '1234.1';
  ///  print(NumUtils.toFormatDownNoZero(numStr: a,precision: 3));//1234.1
  static String toFormatDownNoZero({String? numStr, int? precision}) {
    if (numStr == null || numStr.isEmpty) {
      return numStr ?? '';
    }
    final decimal = Decimal.tryParse(numStr);
    return decimal?.toFormatDownStrNoZero(precision ?? 0) ?? '';
  }

  ///格式化，向下取 [precision] 位小数,不会四舍五入进位,不足补0
  ///  final a = '1234.1234567';
  ///  print(NumUtils.toFormatDownStr(numStr: a,precision: 6)); //1234.123456
  ///final a = '1234';
  ///print(NumUtils.toFormatDownStr(numStr: a,precision: 3)); ///1234.000
  static String toFormatDownStr({String? numStr, int? precision}) {
    if (numStr == null || numStr.isEmpty) {
      return numStr ?? '';
    }
    final decimal = Decimal.tryParse(numStr);
    return decimal?.toFormatDownStr(precision ?? 0) ?? '';
  }

  ///格式化，只有最后一位不是0，则向上进位 不足补0
  ///  final a = '1234.1234567';
  ///  print(NumUtils.toFormatUpStr(numStr: a,precision: 3)); //1234.124
  ///  print(NumUtils.toFormatUpStr(numStr: a,precision: 2)); //1234.13
  ///  final b = '1234';
  ///  print(NumUtils.toFormatUpStr(numStr: b,precision: 3)); //1234.000
  static String toFormatUpStr({String? numStr, int? precision}) {
    if (numStr == null || numStr.isEmpty) {
      return numStr ?? '';
    }
    final decimal = Decimal.tryParse(numStr);
    return decimal?.toFormatUpStr(precision ?? 0) ?? '';
  }

  ///格式化，只有最后一位不是0，则向上进位 不补0
  static String toFormatUpStrNoZero({String? numStr, int? precision}) {
    return toDeleteZero(toFormatUpStr(numStr: numStr, precision: precision)) ??
        '';
  }

  ///删除末尾的0
  static String? toDeleteZero(String? numStr) {
    if (numStr == null || numStr == '') {
      return numStr;
    }
    final int length = numStr.length;
    if (!numStr.contains('.')) {
      return numStr;
    }
    final int pointIndex = numStr.indexOf('.');
    int index = -1;
    for (int i = length - 1; i > 0; i--) {
      final String s = numStr[i];
      if (s != '0' && i > pointIndex) {
        index = i + 1;
        break;
      }
      if (i == pointIndex) {
        index = i;
        break;
      }
    }
    if (index < length) {
      return numStr.substring(0, index);
    } else {
      return numStr;
    }
  }
}

extension _FormatDecimal on Decimal {
  String toFormatDownStr(int precision) {
    return _addZero(precision, toFormatDownStrNoZero(precision));
  }

  String toFormatDownStrNoZero(int precision) {
    return floor(scale: precision).toString();
  }

  String toFormatUpStr(int precision) {
    return _addZero(precision, ceil(scale: precision).toString());
  }

  String _addZero(int precision, String result) {
    if (double.tryParse(result) == null) {
      return result;
    }

    final List<String> split = result.split('.');
    if (precision == 0) {
      result = split.elementAt(0);
    } else {
      if (split.length > 1) {
        final String fraction = split.elementAt(1);
        if (fraction.length < precision) {
          final int diff = precision - fraction.length;
          result += '0' * diff;
        }
      } else if (split.length == 1) {
        result += '.';
        result += '0' * precision;
      }
    }

    return result;
  }
}
