import 'package:apollo/screens/registerUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  @override
  Widget build(BuildContext context) {
    systemColors();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kBackButton(context),
              Center(
                child: Image.asset('lib/assets/icons/doctors-discussion.png'),
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
                // controller: ,
                prefixText: '+91',
                keyboardType: TextInputType.phone,
                hintText: 'Enter 10 digit mobile number',
              ),
              height10,
              kTextField(
                context,
                // controller: ,
                obscureText: true,
                keyboardType: TextInputType.text,
                hintText: 'Enter Password',
              ),
              height50,
              kSubmitButton(context, label: 'Login'),
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
    );
  }
}
