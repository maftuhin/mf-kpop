import 'dart:convert';

import 'package:intl/intl.dart';

class MFUtil {
  MFUtil._();
  static String replace(String? data) {
    var decode = utf8.decode(data?.runes.toList() ?? []);
    return decode
        .replaceAll(":p;", "\n\n")
        .replaceAll(RegExp(":br:|</div>"), "\n")
        .replaceAll(RegExp("&nbsp;|<div>|:p:"), "")
        .replaceAll("&rsquo;", "'");
  }

  static String viewFormat(int? count) {
    var c = NumberFormat.compact().format(count ?? 0);
    return "$c view";
  }
}
