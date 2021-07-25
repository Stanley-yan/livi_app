import 'package:floor/floor.dart';
import 'package:livi_app/Database/ValidationHistory.dart';


@dao
abstract class ValidationHistoryDao
{
  @Query('SELECT * FROM ValidationHistory order by id asc')
  Future<List<ValidationHistory>> getAllValidationHistory();

  @insert
  Future<void> insertValidationHistory(ValidationHistory history);
}