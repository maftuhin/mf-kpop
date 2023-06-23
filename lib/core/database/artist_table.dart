class ArtistTable {
  static const tableName = "artists";
  static const createTable =
      "CREATE TABLE $tableName (id INTEGER PRIMARY KEY, name TEXT, code TEXT)";
}
