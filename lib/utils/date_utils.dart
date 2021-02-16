import 'package:intl/intl.dart';

class DateUtil {

  static const String PATTERN_REDESUL = "yyyy-MM-dd'T'HH:mm:ss";

  static DateTime getDateTime(String dateStrign, String pattern) {
    return new DateFormat(pattern).parse(dateStrign);
  }

  static String format(DateTime date, String pattern){
    return DateFormat(pattern).format(date);
  }


}