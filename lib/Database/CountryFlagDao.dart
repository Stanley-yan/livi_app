import 'package:floor/floor.dart';
import 'package:livi_app/Database/CountryFlag.dart';

@dao
abstract class CountryFlagDao
{
  @Query('SELECT * FROM CountryFlag order by id asc')
  Future<List<CountryFlag>> getAllCountryFlag();

  @insert
  Future<void> insertCountryFlag(CountryFlag flag);
}