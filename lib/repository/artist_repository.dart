import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kpop_lyrics/core/mf_database.dart';
import 'package:kpop_lyrics/core/mf_network.dart';
import 'package:kpop_lyrics/models/m_paging_artist.dart';

class ArtistRepository {
  Future<void> search(
    PagingController pagingController,
    String query,
    int page,
  ) async {
    try {
      var request = await MFNetwork().getUri("artist?query=$query&page=$page");
      if (request.statusCode == 200) {
        var data = PagingArtist.fromJson(request.body);
        if (data.isLastPage()) {
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

  Future<void> searchFromDb(
    PagingController pagingController,
    String query,
    int page,
  ) async {
    final db = MFDatabase.instance;
    final result = await db.searchArtist(page, query);
    if (result.length < 10) {
      pagingController.appendLastPage(result);
    } else {
      pagingController.appendPage(result, page + 1);
    }
  }
}
