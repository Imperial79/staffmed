import 'package:apollo/screens/Profile%20Screen/ordersUI.dart';
import 'package:apollo/screens/dashboardUI.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';

class PaymentUI extends StatefulWidget {
  final String orderId;
  const PaymentUI({super.key, required this.orderId});

  @override
  State<PaymentUI> createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: kBackButton(context),
        automaticallyImplyLeading: false,
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
                fontWeight: FontWeight.w500,
                fontSize: sdp(context, 11),
              ),
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
            Container(
                width: double.infinity,
                height: sdp(context, 180),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/640px-QR_code_for_mobile_English_Wikipedia.svg.png',
                )))),
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              kSubmitButton(
                context,
                onTap: () {
                  cartProductIds = [];
                  cartProducts = [];
                  stockMap = {};
                  navPopUntilPush(context, DashboardUI());
                },
                label: 'Continue shopping',
              ),
              KOutlinedButton.expanded(
                onPressed: () {
                  cartProductIds = [];
                  cartProducts = [];
                  stockMap = {};
                  navPopUntilPush(context, DashboardUI());
                  navPush(context, OrdersUI());
                },
                label: 'Go to orders',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
