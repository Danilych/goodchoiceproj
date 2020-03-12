import 'dart:convert';
import 'dart:async' as das;

import "package:http/http.dart" as http;

User user;

class User {
    String accessToken;
    int id;
    dynamic name;

    User.fromAuth(dynamic data) {
        accessToken = data['access_token'];
        id = data["user_id"];
    }

    User(Map<String, String> data) {
        accessToken = data["access_token"];
        id = int.parse(data["user_id"]);
        name = data["name"];
    }
    Future<http.Response> getName() async {
        Uri api = Uri.https("api.vk.com", "/method/users.get", {"access_token": accessToken, "v": "5.80"});
        return http.get(api, headers: {'user-agent': 'VKAndroidApp/5.40-3904'});
    }
}

Future<http.Response> auth({String login, String password}) async {
    Map<String, String> query = {
      "username": login,
      "password": password,
      "client_id": "2274003",
      "client_secret": "hHbZxrka2uZ6jB1inYsH",
      "grant_type": "password",
      "scope": "268435455",
    };
    Uri oauth = Uri.https("oauth.vk.com", "/token", query);
    return http.get(oauth, headers: {'user-agent': 'VKAndroidApp/5.40-3904'});
}

class API {
    static dynamic request(String method, Map<String, String> data, String token) {

    }
}


String sendCode(String number) {
    return "100";
}


dynamic requestParse(http.Response resp) {
    return jsonDecode(resp.body);
}