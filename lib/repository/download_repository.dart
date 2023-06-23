import 'package:kpop_lyrics/core/mf_database.dart';
import 'package:kpop_lyrics/models/m_artist.dart';

class DownloadRepository {
  DownloadRepository._();

  static Future downloadArtist(MArtist? data) async {
    await MFDatabase.instance.insert("artists", data!.toMap());
  }
}
