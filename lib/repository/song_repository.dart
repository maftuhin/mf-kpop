import 'dart:convert';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kpop_lyrics/core/mf_network.dart';
import 'package:kpop_lyrics/models/m_paging_song.dart';
import 'package:kpop_lyrics/models/m_song.dart';

class SongRepository {
  Future<void> search(
    PagingController pagingController,
    String query,
    int pageKey,
  ) async {
    try {
      final request = await MFNetwork.getUri("song/?q=$query&page=$pageKey");
      if (request.statusCode == 200) {
        final data = SongPaging.fromJson(request.body);
        final isLastPage = data.totalPage == data.page;
        if (isLastPage) {
          pagingController.appendLastPage(data.records);
        } else {
          pagingController.appendPage(data.records, data.nextPage);
        }
      } else {
        pagingController.error = Exception("error");
      }
    } catch (e) {
      pagingController.error = e;
    }
  }

  Future<void> songByArtist(
    PagingController pagingController,
    String artist,
    int pageKey,
  ) async {
    try {
      final request =
          await MFNetwork.getUri("song/artist/$artist?page=$pageKey");
      if (request.statusCode == 200) {
        final data = SongPaging.fromJson(request.body);
        final isLastPage = data.totalPage == data.page;
        if (isLastPage) {
          pagingController.appendLastPage(data.records);
        } else {
          pagingController.appendPage(data.records, data.nextPage);
        }
      } else {
        pagingController.error = Exception("error");
      }
    } catch (e) {
      pagingController.error = e;
    }
  }

  Future<List<MSong>> latest() async {
    try {
      final request = await MFNetwork.getUri("song/latest");
      if (request.statusCode == 200) {
        final body = jsonDecode(request.body);
        return List<MSong>.from(body.map((x) => MSong.fromMap(x)));
      } else {
        return Future.error("error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<MSong>> mostViewed() async {
    try {
      final request = await MFNetwork.getUri("song/most-visited");
      if (request.statusCode == 200) {
        final body = jsonDecode(request.body);
        return List<MSong>.from(body.map((x) => MSong.fromMap(x)));
      } else {
        return Future.error("error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<MSong>> detail(String uid) async {
    try {
      final request = await MFNetwork.getUri("song/$uid");
      if (request.statusCode == 200) {
        final body = jsonDecode(request.body);
        return List<MSong>.from(body.map((x) => MSong.fromMap(x)));
      } else {
        return Future.error("error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> counterView(int id) async {
    try {
      await MFNetwork.getUri("song/counter/$id");
    } catch (e) {
      return Future.error(e);
    }
  }
}
