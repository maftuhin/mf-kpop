import 'package:kpop_lyrics/core/database/database_helper.dart';
import 'package:kpop_lyrics/models/m_artist.dart';

class DownloadRepository {
  Future delete(MArtist data) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete("artists", where: "code='${data.code}'");
  }

  Future saveArtist(MArtist data) async {
    final db = await DatabaseHelper.instance.database;
    db.insert("artists", data.toMap());
  }
}
