import 'package:floor/floor.dart';

@entity
class CountryFlag {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String countryName;
  String countryFlag;
  String countryCode;
  CountryFlag(this.id,this.countryName, this.countryFlag, this.countryCode);
}