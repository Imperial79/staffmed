import 'package:apollo/screens/Auth%20Screens/loginUI.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordUI extends StatefulWidget {
  const ForgotPasswordUI({super.key});

  @override
  State<ForgotPasswordUI> createState() => _ForgotPasswordUIState();
}

class _ForgotPasswordUIState extends State<ForgotPasswordUI> {
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();

    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
  }

  forgotPassword() async {
    setState(() {
      isLoading = true;
    });
    if (password.text == confirmPassword.text) {
      var dataResult = await ApiCallback(
        uri: '/users/forgot-password.php',
        body: {
          'phone': phone.text,
          'newPassword': password.text,
          'confirmPassword': confirmPassword.text,
        },
      );
      setState(() {
        isLoading = false;
      });
      ShowSnackBar(context,
          content: dataResult['message'], isDanger: dataResult['error']);

      if (!dataResult['error']) {
        navPushReplacement(context, LoginUI());
      }
    } else {
      ShowSnackBar(
        context,
        content: 'New password and confirm password must be same',
        isDanger: true,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Center(
                    child: SvgPicture.asset(
                      'lib/assets/icons/forgot-password.svg',
                      height: sdp(context, 200),
                    ),
                  ),
                  height10,
                  Text(
                    'Enter details to continue',
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
                    hintText: 'New Password',
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: confirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Confirm password',
                  ),
                  height20,
                  kSubmitButton(
                    context,
                    onTap: () {
                      forgotPassword();
                    },
                    label: 'Reset',
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
