import 'dart:convert';
import 'dart:async' as das;

import "package:http/http.dart" as http;


Future<http.Response> sendCode(String number) {
    Uri api = Uri.https("evtn.ru", "/sms", {"number": number});
    return http.get(api);
}


dynamic requestParse(http.Response resp) {
    return jsonDecode(resp.body);
}