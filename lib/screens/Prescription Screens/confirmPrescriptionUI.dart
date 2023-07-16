import 'package:apollo/screens/dashboardUI.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConfirmPrescriptionUI extends StatefulWidget {
  final String orderId;
  const ConfirmPrescriptionUI({super.key, required this.orderId});

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
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order placed',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: sdp(context, 17),
              ),
            ),
            height10,
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Order ID is ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: widget.orderId,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade700,
                        fontSize: sdp(context, 15)),
                  ),
                ],
              ),
            ),
            height20,
            Text(
              'We\'ll shortly be processing your order',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: sdp(context, 15),
              ),
            ),
            height20,
            Text(
              'A pharmacist will call you to confirm the medicines you need',
            ),
            height20,
            Expanded(
              child: SvgPicture.asset(
                'lib/assets/icons/calling.svg',
                height: sdp(context, 200),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              navPopUntilPush(context, DashboardUI());
            },
            child: Text('Continue Shopping'),
          ),
        ),
      ),
    );
  }
}
