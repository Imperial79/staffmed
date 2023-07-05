import 'dart:developer';

import 'package:apollo/screens/registerUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final phone = TextEditingController();
  final password = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    var dataResult = await ApiCallback(
      uri: '/users/login.php',
      body: {
        'phone': phone.text,
        'password': password.text,
      },
    );
    log(dataResult.toString());
    if (!dataResult['error']) {}

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    systemColors();
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:
                        Image.asset('lib/assets/icons/doctors-discussion.png'),
                  ),
                  height10,
                  Text(
                    'Log in to continue',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sdp(context, 15),
                    ),
                  ),
                  height20,
                  kTextField(
                    context,
                    controller: phone,
                    prefixText: '+91',
                    keyboardType: TextInputType.phone,
                    hintText: 'Enter 10 digit mobile number',
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    hintText: 'Enter Password',
                  ),
                  height50,
                  kSubmitButton(
                    context,
                    onTap: () {
                      login();
                    },
                    label: 'Login',
                  ),
                  height20,
                  Center(
                    child: TextButton(
                      onPressed: () {
                        navPush(context, RegisterUI());
                      },
                      child: Text(
                        'Already have an account',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: fullScreenLoading(context),
          ),
        ],
      ),
    );
  }
}
