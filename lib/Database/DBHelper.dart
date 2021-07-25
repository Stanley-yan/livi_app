import 'AppDataBase.dart';

class DBHelper {

  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static AppDatabase? _database;

  Future<AppDatabase?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await $FloorAppDatabase.databaseBuilder('liviDB.db').build();
    return _database;
  }

}

