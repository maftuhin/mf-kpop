import 'package:kpop_lyrics/core/mf_database.dart';
import 'package:kpop_lyrics/core/mf_network.dart';
import 'package:kpop_lyrics/models/m_artist.dart';

class DownloadRepository {
  DownloadRepository._();

  static Future downloadArtist(MArtist? data) async {
    await MFDatabase.instance.insert("artists", data!.toMap());
  }

  static Future downloadSongs(String code) async {
    final db = await MFDatabase.instance.database;
    try {
      final result = await MFNetwork.getUri("song/artist/$code");
      // ignore: empty_catches
    } catch (e) {}
  }
}
