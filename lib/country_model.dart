import 'package:livi_app/Database/CountryFlag.dart';

class CountryModel {
  final int id;
  final String name;
  final String flag;
  final String code;

  CountryModel(
      {required this.id, required this.name, required this.flag, required this.code});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json["id"],
      name: json["name"],
      flag: json["flag"],
      code: json["code"],
    );
  }

  factory CountryModel.fromCountryFlag(CountryFlag json) {
    return CountryModel(
      id: json.id!,
      name: json.countryName,
      flag: json.countryFlag,
      code: json.countryCode,
    );
  }


  static List<CountryModel> fromJsonList(List list) {
    return list.map((item) => CountryModel.fromJson(item)).toList();
  }

  static List<CountryModel> fromCountryFlagList(List list) {
    return list.map((item) => CountryModel.fromCountryFlag(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(CountryModel? model) {
    return this.id == model?.id;
  }

  @override
  String toString() => name;
}
