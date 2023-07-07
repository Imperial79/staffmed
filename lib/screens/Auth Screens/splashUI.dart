import 'dart:developer';

import 'package:apollo/screens/dashboardUI.dart';
import 'package:apollo/screens/welcomeUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../utils/constants.dart';

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

  fetchBanners() async {
    var dataResult = await ApiCallback(uri: '/banners/fetch.php');

    if (!dataResult['error']) {
      bannersList = dataResult['response'];
    }
  }

  fetchCartItems() async {
    var dataResult = await ApiCallback(
        uri: '/products/fetch-cart.php', body: {'userId': UserData.id});

    if (!dataResult['error']) {
      cartProducts = dataResult['response'];
      cartProductIds = dataResult['idsArray'];
    }
  }

  validate() async {
    var userBox = await Hive.openBox('userData');

    if (userBox.get('phone') != null && userBox.get('password') != null) {
      reLogin(userBox.get('phone'), userBox.get('password'));
    } else {
      navPushReplacement(context, WelcomeUI());
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
    // log(dataResult.toString());
    if (!dataResult['error']) {
      Map<String, dynamic> userData = dataResult['response'];
      setState(() {
        UserData.fullname = userData['fullname']!;
        UserData.id = userData['id']!;
        UserData.email = userData['email']!;
        UserData.tokenId = userData['tokenId']!;
        UserData.phone = userData['phone']!;
        UserData.date = userData['date']!;
        UserData.addresses = userData['addresses'];
      });
      await fetchCartItems();
      await fetchBanners();
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
