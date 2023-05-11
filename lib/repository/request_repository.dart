import 'package:kpop_lyrics/core/mf_network.dart';
import 'package:kpop_lyrics/models/m_response.dart';

class RequestRepository {
  Future<ApiResponse> sendRequest(String artist, String title) async {
    try {
      final request = await MFNetwork().postUri("request", {
        "artist": artist,
        "title": title,
      });
      if (request.statusCode == 200) {
        return ApiResponse.fromJson(request.body);
      } else {
        return Future.error("error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
