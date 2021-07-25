import 'package:floor/floor.dart';

@entity
class ValidationHistory{
  @PrimaryKey(autoGenerate: true)
  int? id;
  String countryName;
  String countryFlag;
  String countryCode;
  String phoneNo;
  ValidationHistory(this.id,this.countryName, this.countryFlag, this.countryCode,this.phoneNo);
}
