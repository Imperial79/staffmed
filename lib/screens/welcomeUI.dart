import 'package:apollo/screens/loginUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SimpleShadow(
                color: Colors.blue.shade300,
                offset: Offset(10, 10),
                sigma: 40,
                child: Image.asset('lib/assets/icons/pills.png'),
              ),
            ),
            Text(
              'Apollo',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: sdp(context, 25),
              ),
            ),
            height10,
            Padding(
              padding: EdgeInsets.all(8.0),
              child: kSubmitButton(
                context,
                onTap: () {
                  navPush(context, LoginUI());
                },
                label: 'Continue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
