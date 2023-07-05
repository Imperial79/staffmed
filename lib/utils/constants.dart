import 'dart:convert';

import 'package:http/http.dart' as http;

class UserData {
  static String fullname = '';
  static String id = '';
  static String phone = '';
  static String email = '';
  static String tokenId = '';
  static String date = '';
}

String baseUrl = 'https://indiatvonline.in/staffmed/apis';

Future<Map> ApiCallback({
  required String uri,
  Map<String, String>? body,
}) async {
  Uri url = Uri.parse(baseUrl + uri);
  http.Response response = await http.post(
    url,
    headers: {'tokenid': UserData.tokenId},
    body: body ?? {},
  );

  return jsonDecode(response.body);
}
