import 'package:floor/floor.dart';
import 'package:livi_app/Database/CountryFlagDao.dart';
import 'package:livi_app/Database/ValidationHistoryDao.dart';
import 'CountryFlag.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'ValidationHistory.dart';
part 'AppDataBase.g.dart'; // the generated code will be there
@Database(version: 1,entities: [CountryFlag,ValidationHistory])
abstract class AppDatabase extends FloorDatabase
{
  CountryFlagDao get countryFlagDao;
  ValidationHistoryDao get validationHistoryDao;

}

