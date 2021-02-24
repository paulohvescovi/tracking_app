import 'package:intl/intl.dart';

class DateUtil {

  static const String PATTERN_REDESUL = "yyyy-MM-dd'T'HH:mm:ss";
  static const String PATTERN_DEFAULT = "dd/MM HH:mm";
  static const String PATTERN_DATETIME = "dd/MM/yyyy HH:mm";

  static DateTime getDateTime(String dateStrign, String pattern) {
    return new DateFormat(pattern).parse(dateStrign);
  }

  static String format(DateTime date, String pattern){
    return DateFormat(pattern).format(date);
  }


}