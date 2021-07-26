import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TwilioValidation{
  final Dio _dio = Dio();
  static const int _HTTP_OK = 200;

  Future<int> phoneNoValidation(String phoneNo, String flag) async {
    dotenv.load(fileName: "assets/.env");
    _dio.options.baseUrl = dotenv.env['API_URL']!;
    _dio.options.headers =  {'Authorization': dotenv.env['API_AUTH_HEADER']};
    _dio.options.connectTimeout = 3000;
    _dio.options.sendTimeout = 2000;
    _dio.options.receiveTimeout = 2000;
    Response? response ;
    do{
      try {
        String temp = '$phoneNo?CountryCode=$flag';
        response = await _dio.get(temp);
      } on DioError catch (e) {
        if (e.response == null) {
          print("Null repsonse");
          return 404;
        } else if (e.response!.statusCode == _HTTP_OK) {
          print(e.response);
          return _HTTP_OK;
        } else {
          print(e.response);
          return e.response!.statusCode!;
        }
      }
    }
    while(response.statusCode == null || response.statusCode != _HTTP_OK);
    if (response.statusCode == _HTTP_OK) {
      return _HTTP_OK;
    }
    return _HTTP_OK;
  }

}