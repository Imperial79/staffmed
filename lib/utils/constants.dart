import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'components.dart';

class UserData {
  static String fullname = '';
  static String id = '';
  static String phone = '';
  static String email = '';
  static String tokenId = '';
  static String date = '';
}

List<dynamic> cartProducts = [];
List<dynamic> cartProductIds = [];
List<dynamic> searchedProductList = [];
List<dynamic> bannersList = [];

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

addToCart(BuildContext context, String prodId, StateSetter setState) async {
  var dataResult = await ApiCallback(
      uri: '/products/add-to-cart.php',
      body: {'userId': UserData.id, 'productId': prodId});

  ShowSnackBar(context,
      content: dataResult['message'], isDanger: dataResult['error']);
  setState(() {});
}
