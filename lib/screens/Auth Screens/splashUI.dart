import 'dart:developer';

import 'package:apollo/screens/dashboardUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../utils/constants.dart';
import 'loginUI.dart';

class SplashUI extends StatefulWidget {
  const SplashUI({super.key});

  @override
  State<SplashUI> createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> {
  @override
  void initState() {
    super.initState();
    validate();
  }

  fetchCartItems() async {
    var dataResult = await ApiCallback(
        uri: '/products/fetch-cart.php', body: {'userId': UserData.id});

    if (!dataResult['error']) {
      cartList = dataResult['response'];
    }
  }

  validate() async {
    var userBox = await Hive.openBox('userData');

    if (userBox.get('phone') != null && userBox.get('password') != null) {
      reLogin(userBox.get('phone'), userBox.get('password'));
    } else {
      navPushReplacement(context, LoginUI());
    }
  }

  Future<void> reLogin(String phone, String password) async {
    var dataResult = await ApiCallback(
      uri: '/users/login.php',
      body: {
        'phone': phone,
        'password': password,
      },
    );

    if (!dataResult['error']) {
      Map<String, dynamic> userData = dataResult['response'];
      setState(() {
        UserData.fullname = userData['fullname']!;
        UserData.id = userData['id']!;
        UserData.email = userData['email']!;
        UserData.tokenId = userData['tokenId']!;
        UserData.phone = userData['phone']!;
        UserData.date = userData['date']!;
      });

      navPushReplacement(context, DashboardUI());

      ShowSnackBar(
        context,
        content: dataResult['message'],
        isDanger: dataResult['error'],
      );
    } else {
      ShowSnackBar(
        context,
        content: dataResult['message'],
        isDanger: dataResult['error'],
      );
    }

    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Staffmed',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: sdp(context, 30),
                ),
              ),
              Text(
                'We provide always better',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: sdp(context, 15),
                ),
              ),
              height50,
              LinearProgressIndicator(
                color: primaryColor,
              ),
              height10,
              Text('Please wait')
            ],
          ),
        ),
      ),
    );
  }
}
