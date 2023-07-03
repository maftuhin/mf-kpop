import 'package:http/http.dart';

class MFNetwork {
  static const baseUrl = "http://maftuhin.com/";
  static const headers = {"apiKey": "78ad89q94ug"};

  MFNetwork._();

  static Future<Response> getUri(String path) {
    return get(
      Uri.parse(baseUrl + path),
      headers: headers,
    );
  }

  static Future<Response> postUri(String path, Object? object) {
    return post(
      Uri.parse(baseUrl + path),
      body: object,
      headers: headers,
    );
  }
}
