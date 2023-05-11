import 'package:http/http.dart';

class MFNetwork {
  final baseUrl = "http://maftuhin.com/";
  final headers = {"apiKey": "78ad89q94ug"};

  Future<Response> getUri(String path) {
    return get(
      Uri.parse(baseUrl + path),
      headers: headers,
    );
  }

  Future<Response> postUri(String path, Object? object) {
    return post(
      Uri.parse(baseUrl + path),
      body: object,
      headers: headers,
    );
  }
}
