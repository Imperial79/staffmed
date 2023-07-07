import 'package:apollo/screens/Profile%20Screen/ordersUI.dart';
import 'package:apollo/screens/dashboardUI.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';

class CheckoutUI extends StatefulWidget {
  final String orderId;
  const CheckoutUI({super.key, required this.orderId});

  @override
  State<CheckoutUI> createState() => _CheckoutUIState();
}

class _CheckoutUIState extends State<CheckoutUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: kBackButton(context),
        title: kAppbarTitle(context, title: 'Checkout'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your order Id is',
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: sdp(context, 11)),
            ),
            Text(
              widget.orderId,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: sdp(context, 19),
                color: Colors.green.shade700,
              ),
            ),
            height20,
            Text(
              'Proceed to pay',
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: sdp(context, 15)),
            ),
            height20,
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/640px-QR_code_for_mobile_English_Wikipedia.svg.png',
              width: double.infinity,
            ),
            height20,
            Center(
              child: Text(
                'Scan the QR code to pay',
                textAlign: TextAlign.center,
              ),
            ),
            height10,
            Text(
                'Note - After paying, send the screenshot of the confirmation page and transaction page of the UPI app used for payment'),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: KOutlinedButton.expanded(
              onPressed: () {
                navPopUntilPush(context, DashboardUI());
                navPush(context, OrdersUI());
              },
              label: 'Go to orders'),
        ),
      ),
    );
  }
}
