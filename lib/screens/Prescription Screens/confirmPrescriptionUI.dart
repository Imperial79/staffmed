import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConfirmPrescriptionUI extends StatefulWidget {
  const ConfirmPrescriptionUI({super.key});

  @override
  State<ConfirmPrescriptionUI> createState() => _ConfirmPrescriptionUIState();
}

class _ConfirmPrescriptionUIState extends State<ConfirmPrescriptionUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: kBackButton(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              'We\'ll shortly be processing your order',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: sdp(context, 15),
              ),
            ),
            height20,
            Text(
              'A pharmacist will call you to confirm the medicines you need',
            ),
            SvgPicture.asset('lib/assets/icons/calling.svg')
          ],
        ),
      ),
    );
  }
}
