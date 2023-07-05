import 'package:apollo/screens/loginUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Image.asset('lib/assets/icons/pills.png'),
            ),
            Text(
              'Staffmed',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: sdp(context, 25),
              ),
            ),
            height10,
            Image.asset('lib/assets/icons/staffmed-logo.png'),
            height20,
            Padding(
              padding: EdgeInsets.all(8.0),
              child: kSubmitButton(
                context,
                onTap: () {
                  navPushReplacement(context, LoginUI());
                },
                textColor: Colors.black,
                buttonColor: Colors.white,
                label: 'Continue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
