import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kpop_lyrics/core/mf_network.dart';
import 'package:kpop_lyrics/models/m_paging_ost.dart';
import 'package:kpop_lyrics/models/m_paging_song.dart';

class OstRepository {
  Future<void> search(
    String query,
    int page,
    PagingController pageController,
  ) async {
    try {
      final request =
          await MFNetwork().getUri("soundtrack?q=$query&page=$page");
      if (request.statusCode == 200) {
        final data = SoundtrackPaging.fromJson(request.body);
        if (data.page == data.totalPage) {
          pageController.appendLastPage(data.records);
        } else {
          pageController.appendPage(data.records, data.nextPage);
        }
      } else {
        pageController.error = Exception("error");
      }
    } catch (e) {
      pageController.error = e;
    }
  }

  Future<void> soundtrackList(
    String code,
    int page,
    PagingController controller,
  ) async {
    try {
      final request = await MFNetwork().getUri("soundtrack/$code?page=$page");
      if (request.statusCode == 200) {
        final data = SongPaging.fromJson(request.body);
        if (data.page == data.totalPage) {
          controller.appendLastPage(data.records);
        } else {
          controller.appendPage(data.records, data.nextPage);
        }
      } else {
        controller.error = Exception("error");
      }
    } catch (e) {
      controller.error = e;
    }
  }
}
