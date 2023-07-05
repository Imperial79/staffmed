import 'dart:developer';

import 'package:apollo/screens/dashboardUI.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/sdp.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final fullname = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isLoading = false;

  Future<void> register() async {
    setState(() {
      isLoading = true;
    });
    if (confirmPassword.text == password.text) {
      var dataResult = await ApiCallback(
        uri: '/users/register.php',
        body: {
          'fullname': fullname.text,
          'email': email.text,
          'phone': phone.text,
          'password': password.text,
        },
      );
      log(dataResult.toString());
      if (!dataResult['error']) {}

      ShowSnackBar(
        context,
        content: dataResult['message'],
        isDanger: dataResult['error'],
      );
    }

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
                  kBackButton(context),
                  height20,
                  Center(
                    child: SvgPicture.asset(
                      'lib/assets/icons/medicine-pills.svg',
                      height: sdp(context, 130),
                    ),
                  ),
                  height20,
                  Text(
                    'Register to continue',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sdp(context, 15),
                    ),
                  ),
                  height20,
                  kTextField(
                    context,
                    controller: fullname,
                    keyboardType: TextInputType.name,
                    hintText: 'Enter Fullname',
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter Email',
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: phone,
                    prefixText: '+91',
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    hintText: 'Enter 10 digit mobile number',
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    hintText: 'Enter password',
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: confirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Confirm password',
                  ),
                  height50,
                  kSubmitButton(
                    context,
                    onTap: () {
                      register();
                    },
                    label: 'Register',
                  ),
                  height10,
                  GestureDetector(
                    onTap: () {},
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: sdp(context, 10),
                      ),
                      TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  'By registering to Apollo you agree to our '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(visible: isLoading, child: fullScreenLoading(context)),
        ],
      ),
    );
  }
}
