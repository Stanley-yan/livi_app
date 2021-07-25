// utils.dart

import 'dart:convert' show base64, utf8;

const String TWILIO_SMS_API_BASE_URL = 'https://api.twilio.com/2010-04-01';

// returns base64 encoded Twilio credentials
// used in authorization headers of http requests
String toAuthCredentials(String accountSid, String authToken){
   String result = base64.encode(utf8.encode(accountSid + ':' + authToken));
   print(result);
   return result;
}
