import 'dart:convert';

class MFUtil {
  String replace(String? data) {
    var decode = utf8.decode(data?.runes.toList() ?? []);
    return decode
        .replaceAll(":p;", "\n\n")
        .replaceAll(RegExp(":br:|</div>"), "\n")
        .replaceAll(RegExp("&nbsp;|<div>|:p:"), "")
        .replaceAll("&rsquo;", "'");
  }
}
